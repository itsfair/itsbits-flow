import 'package:serverpod/serverpod.dart';

import '../auth/scopes.dart';
import '../generated/protocol.dart';
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
      final profile = task.profile;
      if (profile == null) {
        await _failTask(session, task, 'member_profile fehlt.');
        continue;
      }
      var membership = membershipsByProfile[task.profileId];
      if (membership == null) {
        await _failTask(
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
          profileId: profile.id!,
          globalAuthUserId: profile.authUserId,
          email: profile.email,
          firstName: profile.firstName,
          lastName: profile.lastName,
          birthday: profile.birthday,
          imageUrl: profile.imageUrl,
          roleName: membership.role.name,
          active: membership.active,
          endedAt: membership.endedAt,
          doorCodeSecret: doorCodeSecret,
          membershipCreatedAt: membership.createdAt,
        ),
      );
    }
    return result;
  }

  /// Deletes the confirmed task rows (scoped to the calling site — the
  /// local instance never sees other sites' ids anyway).
  Future<void> confirmProcessed(
    final Session session, {
    required final List<int> taskIds,
  }) async {
    final site = await requireDeviceSite(session);
    if (taskIds.isEmpty) return;
    await SiteSyncTask.db.deleteWhere(
      session,
      where: (t) => t.id.inSet(taskIds.toSet()) & t.siteId.equals(site.id!),
    );
  }

  // -- Private helpers

  Future<void> _failTask(
    final Session session,
    final SiteSyncTask task,
    final String message,
  ) async {
    await SiteSyncTask.db.updateRow(
      session,
      task.copyWith(
        attempts: task.attempts + 1,
        lastError: message,
      ),
      columns: (t) => [t.attempts, t.lastError],
    );
  }
}
