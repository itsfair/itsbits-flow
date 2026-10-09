import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../auth/scopes.dart';
import '../generated/protocol.dart';
import 'site_sync_notifier.dart';

/// Device connection endpoint for the local instance.
///
/// The local instance opens a long-lived method stream on [connect] and
/// keeps sending [SitePing]s. Each ping refreshes `site.lastSeenAt` (the
/// per-site connection chip in the admin UI derives its state from that).
///
/// The stream is genuinely duplex: [SiteSyncNotifier]-triggered server
/// events (`needsSiteSync`) are yielded spontaneously too, so the local
/// instance can pull pending member-data deliveries in real time instead
/// of waiting up to a ping interval. A `needsSiteSync` event is also
/// yielded once at stream start so a freshly (re-)connected site pulls
/// everything queued while it was offline.
///
/// The site is resolved from the enrolled `SiteDeviceSession` mapping via
/// the SAS session id (`session.authenticated!.authId`).
///
/// Live status broadcast to admin clients (Serverpod message central) is a
/// To-do; the admin list currently polls.
class SiteConnectionEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {const Scope(kSiteDeviceScope)};

  /// The device connection stream. Pings keep the connection and the site
  /// freshness alive; the stream stays open until the client closes it or
  /// an error occurs (client handles reconnects; if the credential was
  /// revoked, a reconnect fails with an auth error and the local instance
  /// switches to `needsReSetup`).
  Stream<SiteEvent> connect(
    final Session session,
    final Stream<SitePing> pings,
  ) async* {
    final site = await _requireSite(session);

    await _touch(session, site);

    // Merge the incoming pings with the in-process sync notifications into
    // one event loop: ping -> touch/pong, notification -> needsSiteSync.
    final events = StreamController<(SitePing? ping, SiteEvent? sync)>();
    final syncNotifier = StreamController<SiteEvent>();

    SiteSyncNotifier.instance.register(site.id!, syncNotifier);

    final pingsSubscription = pings.listen(
      (ping) => events.add((ping, null)),
      onError: events.addError,
      onDone: events.close,
      cancelOnError: true,
    );
    final syncSubscription = syncNotifier.stream.listen(
      (syncEvent) => events.add((null, syncEvent)),
      onDone: events.close,
      cancelOnError: true,
    );

    try {
      yield SiteEvent(
        needsSiteSync: true,
        sentAtMs: DateTime.now().millisecondsSinceEpoch,
      );

      await for (final (ping, syncEvent) in events.stream) {
        if (ping != null) {
          await _touch(session, site);
          yield SiteEvent(
            pongSentAtMs: DateTime.now().millisecondsSinceEpoch,
            pingSentAtMs: ping.sentAtMs,
            sentAtMs: DateTime.now().millisecondsSinceEpoch,
            // The heartbeat doubles as the delivery backstop: signal pending
            // work without any data transfer (queued rows, seen tasks, etc.
            // are pulled from `siteSync` only after this flag).
            needsSiteSync: await _hasPendingSync(session, site),
          );
        } else if (syncEvent?.needsSiteSync == true) {
          yield SiteEvent(
            needsSiteSync: true,
            sentAtMs: DateTime.now().millisecondsSinceEpoch,
          );
        }
      }
    } finally {
      SiteSyncNotifier.instance.unregister(site.id!, syncNotifier);
      await syncSubscription.cancel();
      unawaited(events.close());
      await pingsSubscription.cancel();
    }
  }

  // -- Private helpers

  /// Resolves the site of this device session via the SAS session id.
  Future<Site> _requireSite(final Session session) async {
    final authInfo = session.authenticated;
    final sessionId = authInfo?.authId;
    if (authInfo == null || sessionId == null) {
      throw SiteAdminException(message: 'Nicht authentifiziert.');
    }

    final deviceSession = await SiteDeviceSession.db.findFirstRow(
      session,
      where: (t) => t.serverSideSessionId.equals(
        UuidValue.fromString(sessionId),
      ),
    );
    if (deviceSession == null) {
      throw SiteAdminException(
        message:
            'Device-Session unbekannt oder widerrufen — bitte neu einrichten.',
      );
    }

    final site = await Site.db.findFirstRow(
      session,
      where: (t) => t.id.equals(deviceSession.siteId),
    );
    if (site == null) {
      throw SiteAdminException(message: 'Site fehlt — bitte neu einrichten.');
    }
    return site;
  }

  Future<void> _touch(final Session session, final Site site) async {
    await Site.db.updateRow(
      session,
      site.copyWith(lastSeenAt: DateTime.now()),
    );
  }

  /// Cheap existence check for queued member-data deliveries (indexed by
  /// siteId; first matching row only).
  Future<bool> _hasPendingSync(final Session session, final Site site) async {
    return (await SiteSyncTask.db.find(
      session,
      where: (t) => t.siteId.equals(site.id!),
      limit: 1,
    )).isNotEmpty;
  }
}
