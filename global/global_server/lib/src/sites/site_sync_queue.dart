import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'site_sync_notifier.dart';

/// Pending member-data deliveries to the local instances (the queue IS the
/// source of truth; written before any push attempt so nothing is lost when
/// a site's connection dies mid-transfer).
///
/// One row per (site, profile) — unique index — since the delivery payload
/// always assembles the current global state; multiple changes of the same
/// person collapse. Rows are removed only when the local instance confirms
/// processing (`SiteSyncEndpoint.confirmProcessed`), never by delivery.
/// Site removal cascades the rows away (backlog: admin delete-site flow).
abstract final class SiteSyncQueue {
  /// Latest-pull cap per call (local pulls again at its next ping).
  static const int maxBatchSize = 100;

  /// Delivery-attempt cap: a task that has been pulled (or failed its
  /// data check) this many times without a confirm is DROPPED from
  /// delivery and alarms exactly once (the row stays for diagnosis —
  /// a re-enqueue of the same person resets it, see collapse below).
  /// Persistent non-applying tasks usually come from permanent trouble
  /// at that site (image transfer, storage outage); delivery would
  /// otherwise retry at every ping forever.
  static const int maxDeliveryAttempts = 50;

  /// Enqueues current-state deliveries for every site the profile has an
  /// ACTIVE membership at; used by all global profile edits (`save`,
  /// `setUserImage`, `removeUserImage`).
  static Future<void> enqueueForProfile(
    final Session session,
    final int profileId,
  ) async {
    final memberships = await SiteMembership.db.find(
      session,
      where: (t) => t.profileId.equals(profileId) & t.active.equals(true),
    );
    await enqueueForSites(
      session,
      profileId: profileId,
      siteIds: memberships.map((m) => m.siteId),
    );
  }

  /// Upserts the per-(site, profile) task rows and pushes the connected
  /// sites immediately over their method stream.
  static Future<void> enqueueForSites(
    final Session session, {
    required final int profileId,
    required final Iterable<int> siteIds,
  }) async {
    for (final siteId in siteIds) {
      await SiteSyncTask.db.upsertRow(
        session,
        SiteSyncTask(siteId: siteId, profileId: profileId),
        conflictColumns: (t) => [t.siteId, t.profileId],
        updateColumns: (t) => [t.createdAt, t.attempts, t.lastError],
      );
      SiteSyncNotifier.instance.notifySite(siteId);
    }
  }
}
