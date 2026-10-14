import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:global_client/global_client.dart' as gc;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'global_site_connection.dart';

/// Processes the global instance's pending member-data deliveries for this
/// site (pull model): every payload assembles the CURRENT global state for
/// one person — applied as an idempotent upsert, so a re-pull after a
/// failed attempt is always safe (at-least-once delivery).
///
/// Delivery rules:
/// - Fresh member (no local copy): the image transfer is fail-fast, the
///   enrollment principle — a download failure leaves nothing behind.
/// - Existing member: text fields are always applied; the image is
///   best-effort downloaded/overwritten (or locally removed when the
///   global-side image is gone). The task is only confirmed when the
///   whole payload succeeded.
/// - Deactivated memberships (active=false + endedAt): only the mirror
///   marker changes — person data is kept for later viewing.
///
/// Runs at every connection event (the global backend pushes a
/// `needsSiteSync` event at stream start and on every queue write; pings
/// every 30 s act as the watchdog).
class SiteSyncProcessor {
  SiteSyncProcessor._();

  static final SiteSyncProcessor instance = SiteSyncProcessor._();

  bool _busy = false;

  /// Pulls and applies one batch of pending deliveries. Overlapping runs
  /// are collapsed (a new event while processing simply becomes a no-op;
  /// the next ping re-checks anyway).
  Future<void> processPending() async {
    if (_busy) return;
    _busy = true;
    try {
      final appliedTaskIds = await _pullAndApply();
      if (appliedTaskIds.isNotEmpty) {
        final client = await _openSyncClient();
        if (client != null) {
          await client.siteSync.confirmProcessed(taskIds: appliedTaskIds);
        }
      }
    } on Object catch (error) {
      stderr.writeln(
        '[SiteSyncProcessor] pull/apply failed: $error',
      );
    } finally {
      _busy = false;
    }
  }

  // -- Batching

  Future<List<int>> _pullAndApply() async {
    final client = await _openSyncClient();
    if (client == null) return [];

    final tasks = await client.siteSync.pullPending();
    final appliedTaskIds = <int>[];
    for (final task in tasks) {
      if (await _applyMember(task)) {
        appliedTaskIds.add(task.taskId);
      }
    }
    return appliedTaskIds;
  }

  /// An authenticated global client for this instance's device session
  /// (owned by the connection worker — same wiring).
  Future<gc.Client?> _openSyncClient() =>
      GlobalSiteConnection.instance.openSyncClient();

  // -- Per-member application

  Future<bool> _applyMember(final gc.SiteSyncMember member) async {
    return Serverpod.instance.withSession((session) async {
      final existing = await MemberProfile.db.findFirstRow(
        session,
        where: (t) => t.globalAuthUserId.equals(member.globalAuthUserId),
      );

      // Image bytes FIRST (fail-fast for fresh members — enrollment
      // principle: no half-created persons).
      ByteData? imageBytes;
      final hasGlobalImage =
          member.imageUrl != null && member.imageUrl!.isNotEmpty;
      if (hasGlobalImage) {
        imageBytes = await _downloadBytes(member.imageUrl!);
        if (imageBytes == null) {
          stderr.writeln(
            '[SiteSyncProcessor] image transfer failed for '
            '${member.globalAuthUserId} — task ${member.taskId} stays '
            'pending.',
          );
          return false;
        }
      }

      await session.db.transaction((final transaction) async {
        var profile =
            existing ??
            await MemberProfile.db.insertRow(
              session,
              MemberProfile(
                globalAuthUserId: member.globalAuthUserId,
                email: member.email,
                firstName: member.firstName,
                lastName: member.lastName,
                birthday: member.birthday,
              ),
              transaction: transaction,
            );

        profile = await MemberProfile.db.updateRow(
          session,
          profile.copyWith(
            email: member.email,
            firstName: member.firstName,
            lastName: member.lastName,
            birthday: member.birthday,
          ),
          transaction: transaction,
        );

        if (hasGlobalImage && imageBytes != null) {
          await session.storage.storeFile(
            storageId: 'public',
            path: _imagePath(member.globalAuthUserId),
            byteData: imageBytes,
          );
          final publicUrl = await session.storage.publicDownloadUrl(
            storageId: 'public',
            path: _imagePath(member.globalAuthUserId),
          );
          profile = await MemberProfile.db.updateRow(
            session,
            profile.copyWith(imageUrl: publicUrl.toString()),
            transaction: transaction,
          );
        } else if (!hasGlobalImage && profile.imageUrl != null) {
          // Global image removed: mirror the removal locally.
          await session.storage.deleteFile(
            storageId: 'public',
            path: _imagePath(member.globalAuthUserId),
          );
          profile = await MemberProfile.db.updateRow(
            session,
            profile.copyWith(imageUrl: null),
            transaction: transaction,
          );
        }

        final membership = await MemberMembership.db.findFirstRow(
          session,
          where: (t) => t.globalAuthUserId.equals(member.globalAuthUserId),
          transaction: transaction,
        );
        if (membership == null) {
          await MemberMembership.db.insertRow(
            session,
            MemberMembership(
              memberProfileId: profile.id!,
              globalAuthUserId: member.globalAuthUserId,
              role: MemberRole.fromJson(member.roleName),
              active: member.active,
              endedAt: member.endedAt,
              createdAt: member.membershipCreatedAt ?? DateTime.now(),
            ),
            transaction: transaction,
          );
        } else {
          await MemberMembership.db.updateRow(
            session,
            membership.copyWith(
              role: MemberRole.fromJson(member.roleName),
              active: member.active,
              endedAt: member.endedAt,
            ),
            transaction: transaction,
          );
        }
      });

      return true;
    });
  }

  /// Deterministic image object path (parity with the global instance).
  String _imagePath(final UuidValue globalAuthUserId) =>
      'member_images/$globalAuthUserId.jpg';

  Future<ByteData?> _downloadBytes(final String url) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }
      final builder = BytesBuilder(copy: false);
      await for (final chunk in response) {
        builder.add(chunk);
      }
      return ByteData.sublistView(builder.takeBytes());
    } finally {
      client.close(force: true);
    }
  }
}
