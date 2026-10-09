import '../generated/protocol.dart';

/// Connectivity heuristic shared by all site clients (admin chips, end-user
/// app): a site counts as "connected" when its local instance pinged within
/// the freshness window (heartbeat every 30 s, plus slack).
abstract final class SiteConnectionStatus {
  static const Duration freshnessWindow = Duration(seconds: 90);

  static bool isConnected(final Site site) {
    final lastSeen = site.lastSeenAt;
    if (lastSeen == null) return false;
    return DateTime.now().difference(lastSeen) <= freshnessWindow;
  }
}
