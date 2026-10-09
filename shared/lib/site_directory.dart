import 'package:flutter/foundation.dart';

/// Plain-data view of a site ("Betrieb"), independent of any generated
/// backend client. Host apps map their own generated model onto this
/// struct (global `SiteDirectoryEndpoint.project` types at the moment).
class SiteData {
  final int id;

  final String name;

  final String street;

  final String zipCode;

  final String city;

  final String country;

  /// Contact email of the operating company (public).
  final String companyEmail;

  /// Public site image URL (null = placeholder rendering).
  final String? imageUrl;

  /// Computed server-side from the device heartbeat freshness.
  final bool isOnline;

  /// Optional custom chip label overriding the online/offline default
  /// (e.g. "Setup offen" in the admin app for not-yet-enrolled sites).
  final String? statusLabel;

  /// When the site record was created (lists sort newest first).
  final DateTime createdAt;

  const SiteData({
    required this.id,
    required this.name,
    required this.street,
    required this.zipCode,
    required this.city,
    required this.country,
    required this.companyEmail,
    required this.isOnline,
    required this.createdAt,
    this.imageUrl,
    this.statusLabel,
  });
}

/// Plain-data view of the signed-in user's membership at a site.
class MyMembershipData {
  final int siteId;

  /// member/staff/siteAdmin (role name from the backend).
  final String roleName;

  /// Lifecycle: false = deactivated (data kept, only a marker).
  final bool active;

  /// Deactivation marker (null while active).
  final DateTime? endedAt;

  /// When the membership was created.
  final DateTime createdAt;

  const MyMembershipData({
    required this.siteId,
    required this.roleName,
    required this.active,
    required this.createdAt,
    this.endedAt,
  });
}

/// Backend contract for the site directory. Host apps implement this
/// against their own generated client (~20 lines, one adapter file) and
/// inject it into the shared widgets. Browsing is unsigned-in-allowed by
/// the backend; subscribe/unsubscribe require an authenticated user whose
/// profile data is complete (server-side enforcement).
abstract interface class SiteDirectoryApi {
  Future<List<SiteData>> listLatest({final int limit});

  Future<List<SiteData>> list({
    final String? query,
    final int offset,
    final int limit,
  });

  Future<int> count({final String? query});

  Future<SiteData> getSite(final int siteId);

  Future<MyMembershipData?> myMembership(final int siteId);

  Future<MyMembershipData> subscribe(final int siteId);

  Future<void> unsubscribe(final int siteId);
}

/// Holds the end-user's membership bookkeeping in flight (whether the FAB
/// shows subscribe or "my membership"); hosts may use it instead of their
/// own state. Memberships only ever change through explicit UI actions —
/// the backend is the source of truth.
class SiteMembershipState extends ChangeNotifier {
  MyMembershipData? membership;

  void set(final MyMembershipData? value) {
    membership = value;
    notifyListeners();
  }
}
