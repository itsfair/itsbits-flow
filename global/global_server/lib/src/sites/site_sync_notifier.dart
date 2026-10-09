import 'dart:async';

import '../generated/protocol.dart';

/// In-process registry of the currently connected device streams, keyed by
/// site id. Queue writes ("site has pending sync data") notify through this
/// so the global backend can yield a `SiteEvent` spontaneously — real-time
/// push on the duplex method stream (no more pong-only responses).
///
/// Source of truth for reliability stays the `site_sync_tasks` queue (rows
/// are deleted only after confirmed processing); a missed push is healed by
/// the local instance's pull at its next ping (<= 30 s). Multi-instance
/// deployments need message-bus plumbing here (TODO: Redis pub/sub).
class SiteSyncNotifier {
  SiteSyncNotifier._();

  static final SiteSyncNotifier instance = SiteSyncNotifier._();

  final Map<int, StreamController<SiteEvent>> _connections =
      <int, StreamController<SiteEvent>>{};

  /// Registers a live connection of the given site. Exactly one connection
  /// per site is expected (single device credential); a later registration
  /// for the same id replaces the stale one.
  void register(
    final int siteId,
    final StreamController<SiteEvent> controller,
  ) {
    _connections[siteId] = controller;
  }

  void unregister(
    final int siteId,
    final StreamController<SiteEvent> controller,
  ) {
    if (identical(_connections[siteId], controller)) {
      _connections.remove(siteId);
    }
  }

  /// True when a live connection is registered (queue helpers can skip the
  /// push attempt; the local pulls at every ping anyway).
  bool isConnected(final int siteId) => _connections[siteId]?.isClosed == false;

  /// Pushes a `needsSiteSync` event to the site if it is currently
  /// connected. Best effort: a silently failing further on the closed
  /// controller is tolerated (the queue heals the delivery).
  void notifySite(final int siteId) {
    final controller = _connections[siteId];
    if (controller == null || controller.isClosed) return;
    try {
      controller.add(
        SiteEvent(
          needsSiteSync: true,
          sentAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } on Object {
      _connections.remove(siteId);
    }
  }
}
