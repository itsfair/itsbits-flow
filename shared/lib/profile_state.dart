import 'package:flutter/foundation.dart';

/// Plain-data view of a member profile, independent of any generated
/// backend client. Host apps map their own generated model (global
/// `MemberProfile`, local mirror, …) onto this struct.
class MemberProfileData {
  /// Auth user id as string (the composed profile id / door key of the
  /// person, rendered as text + QR code in the shared profile screen).
  final String authUserId;

  /// Lowercase registration email.
  final String email;

  /// Profile names (optional until completed after registration).
  final String? firstName;
  final String? lastName;

  /// Birthday as UTC-midnight date sentinel (see backend AGENTS.md).
  final DateTime? birthday;

  /// Public URL of the profile image (RustFS; null until set).
  final String? imageUrl;

  const MemberProfileData({
    required this.authUserId,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.imageUrl,
  });
}

/// The profile operations the shared components need. Host apps implement
/// this against their own generated client (the `memberProfile` endpoints
/// have the same shape on every instance).
abstract interface class MemberProfileApi {
  Future<MemberProfileData> get();

  Future<MemberProfileData> save({
    required final String firstName,
    required final String lastName,
    required final DateTime birthday,
  });

  Future<MemberProfileData> setUserImage({required final ByteData image});

  Future<MemberProfileData> removeUserImage();
}

/// Holds the profile data of the signed-in user, read/written through the
/// injected [MemberProfileApi]. Consumed by the end-user app and the admin
/// apps identically — changes here apply to all of them.
class ProfileState extends ChangeNotifier {
  final MemberProfileApi _api;

  ProfileState(this._api);

  MemberProfileData? _profile;
  bool _loaded = false;

  /// The signed-in user's own member profile (email, person id, names,
  /// birthday, image url).
  MemberProfileData? get profile => _profile;

  /// Composed full name (firstName + lastName), for display/avatar.
  String? get fullName {
    final parts = [
      _profile?.firstName,
      _profile?.lastName,
    ].whereType<String>().where((part) => part.isNotEmpty);
    final joined = parts.join(' ').trim();
    return joined.isEmpty ? null : joined;
  }

  /// Public image URL of the profile image (string form for the shared
  /// widgets).
  String? get imageUrl {
    final url = _profile?.imageUrl;
    return url == null || url.isEmpty ? null : url;
  }

  /// True once the data has been fetched from the server after signing in.
  bool get loaded => _loaded;

  /// True when all mandatory fields (first name, last name, birthday) are
  /// set. The profile image is optional.
  ///
  /// The end-user app uses this to force profile completion; admin apps
  /// deliberately ignore it (admins may sign in without a completed
  /// profile).
  bool get isComplete {
    final profile = _profile;
    return profile != null &&
        profile.firstName != null &&
        profile.lastName != null &&
        profile.birthday != null;
  }

  /// Loads the profile from the server.
  ///
  /// Auth is enforced by the server (requireLogin); this method is only
  /// triggered by the auth listener while signed in. Admin apps must not
  /// force profile completion (see consumer).
  Future<void> load() async {
    _profile = await _api.get();
    _loaded = true;
    notifyListeners();
  }

  /// Replaces locally known parts of the state after a successful save,
  /// so the UI updates without another round trip.
  void update({MemberProfileData? profile}) {
    if (profile != null) _profile = profile;
    notifyListeners();
  }

  /// Clears all state after sign-out.
  void reset() {
    _profile = null;
    _loaded = false;
    notifyListeners();
  }
}
