import 'package:serverpod/serverpod.dart';

import '../auth/scopes.dart';
import '../generated/protocol.dart';
import '../images/image_url_signer.dart';
import 'door_code_secrets.dart';
import 'site_device_context.dart';
import 'site_sync_queue.dart';

/// Member-data sync pull endpoint for the local instances (`site-device`
/// scope), the counterpart of [SitesAdminEndpoint]'s device connection:
///
/// - `pullPending` assembles a batch of pending deliveries from the CURRENT
///   global state (one payload per (site, profile); entries collapse, see
///   `SiteSyncQueue`).
/// - After successfully applying a payload locally, the local instance
///   confirms via [confirmProcessed] — only then the task row is deleted
///   (at-least-once delivery; failed items stay with attempts/lastError).
class SiteSyncEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {const Scope(kSiteDeviceScope)};

  /// Pending deliveries for this site's local instance (oldest first).
  Future<List<SiteSyncMember>> pullPending(final Session session) async {
    final site = await requireDeviceSite(session);

    final tasks = await SiteSyncTask.db.find(
      session,
      where: (t) => t.siteId.equals(site.id!),
      orderBy: (t) => t.createdAt,
      limit: SiteSyncQueue.maxBatchSize,
      include: SiteSyncTask.include(profile: MemberProfile.include()),
    );

    if (tasks.isEmpty) return [];

    final profileIds = tasks.map((t) => t.profileId).toSet();
    final memberships = await SiteMembership.db.find(
      session,
      where: (t) => t.siteId.equals(site.id!) & t.profileId.inSet(profileIds),
      include: SiteMembership.include(profile: MemberProfile.include()),
    );
    final membershipsByProfile = <int, SiteMembership>{
      for (final membership in memberships) membership.profileId: membership,
    };

    final result = <SiteSyncMember>[];
    for (final task in tasks) {
      if (task.attempts >= SiteSyncQueue.maxDeliveryAttempts) {
        continue;
      }
      final profile = task.profile;
      if (profile == null) {
        await _bumpAttempts(session, task, 'member_profile fehlt.');
        continue;
      }
      var membership = membershipsByProfile[task.profileId];
      if (membership == null) {
        await _bumpAttempts(
          session,
          task,
          'SiteMembership fehlt (unexpectly removed).',
        );
        continue;
      }
      // Self-healing backfill: legacy memberships without a door secret
      // get one at pull time (active memberships only — inactive ones
      // can never verify, so their secret stays null).
      var doorCodeSecret = membership.doorCodeSecret;
      if (doorCodeSecret == null && membership.active) {
        membership = await SiteMembership.db.updateRow(
          session,
          membership.copyWith(doorCodeSecret: generateDoorCodeSecret()),
        );
        doorCodeSecret = membership.doorCodeSecret;
      }
      result.add(
        SiteSyncMember(
          taskId: task.id!,
          taskCreatedAt: task.createdAt,
          profileId: profile.id!,
          globalAuthUserId: profile.authUserId,
          email: profile.email,
          firstName: profile.firstName,
          lastName: profile.lastName,
          birthday: profile.birthday,
          imageUrl: await ImageUrlSigner.signedWithExpiry(
            session,
            profile.imageUrl,
            const Duration(minutes: 5),
          ),
          roleName: membership.role.name,
          active: membership.active,
          endedAt: membership.endedAt,
          doorCodeSecret: doorCodeSecret,
          membershipCreatedAt: membership.createdAt,
        ),
      );
      await _bumpAttempts(session, task, null);
    }
    return result;
  }

  /// Deletes the confirmed task rows OPTIMISTICALLY (scoped to the calling
  /// site): a row is removed only while it still carries the createdAt the
  /// local instance actually saw. An enqueue that raced the pull re-regs
  /// its newer state by bumping createdAt — that marker survives the stale
  /// confirm and is delivered at the next watchdog ping / notify.
  Future<void> confirmProcessed(
    final Session session, {
    required final List<SiteSyncConfirmation> confirmations,
  }) async {
    final site = await requireDeviceSite(session);
    if (confirmations.isEmpty) return;
    for (final confirmation in confirmations) {
      await SiteSyncTask.db.deleteWhere(
        session,
        where: (t) =>
            t.id.equals(confirmation.taskId) &
            t.siteId.equals(site.id!) &
            t.createdAt.equals(confirmation.taskCreatedAt),
      );
    }
  }

  // -- Private helpers

  /// Counts one delivery/no-deliverable-data cycle against the attempt
  /// cap ([SiteSyncQueue.maxDeliveryAttempts]) and alarms EXACTLY ONCE
  /// per capped task (equality check on the cap value; capped tasks then
  /// skip delivery above — see [pullPending] — until a re-enqueue resets
  /// attempts, [SiteSyncQueue.enqueueForSites]).
  Future<void> _bumpAttempts(
    final Session session,
    final SiteSyncTask task,
    final String? error,
  ) async {
    final attempts = task.attempts + 1;
    await SiteSyncTask.db.updateRow(
      session,
      task.copyWith(attempts: attempts, lastError: error),
      columns: (t) => [t.attempts, t.lastError],
    );
    if (attempts == SiteSyncQueue.maxDeliveryAttempts) {
      session.log(
        '[SiteSync] attempt cap reached: site ${task.siteId}, profile '
        '${task.profileId}, task ${task.id} is DROPPED from delivery. '
        'Check that site\'s server logs (apply/image failures); a new '
        'change for the person re-enqueues a fresh delivery.',
        level: LogLevel.error,
      );
    }
  }
}
