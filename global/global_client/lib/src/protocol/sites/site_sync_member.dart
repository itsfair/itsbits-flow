/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// One member-data delivery assembled from the CURRENT global state at
/// pull time (queue entries collapse, so the payload is always "now").
/// The local instance applies this as an upsert of the person's mirror
/// row plus its membership mirror; `active=false` deactivates locally
/// (data is kept, not deleted).
abstract class SiteSyncMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SiteSyncMember._({
    required this.taskId,
    required this.profileId,
    required this.globalAuthUserId,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.imageUrl,
    required this.roleName,
    required this.active,
    this.endedAt,
    this.doorCodeSecret,
    this.membershipCreatedAt,
  });

  factory SiteSyncMember({
    required int taskId,
    required int profileId,
    required _isc.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? imageUrl,
    required String roleName,
    required bool active,
    DateTime? endedAt,
    String? doorCodeSecret,
    DateTime? membershipCreatedAt,
  }) = _SiteSyncMemberImpl;

  factory SiteSyncMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteSyncMember(
      taskId: jsonSerialization['taskId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      globalAuthUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      email: jsonSerialization['email'] as String,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
      birthday: jsonSerialization['birthday'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['birthday']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      roleName: jsonSerialization['roleName'] as String,
      active: _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      doorCodeSecret: jsonSerialization['doorCodeSecret'] as String?,
      membershipCreatedAt: jsonSerialization['membershipCreatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['membershipCreatedAt'],
            ),
    );
  }

  /// Id of the site_sync_tasks row this payload belongs to (used by the
  /// local instance to confirm processing).
  int taskId;

  /// Global member_profile id (reference only).
  int profileId;

  /// The exchange id (global authUserId / door key / image-object key).
  _isc.UuidValue globalAuthUserId;

  String email;

  String? firstName;

  String? lastName;

  DateTime? birthday;

  /// Public image URL on the global instance (null = no image; the local
  /// instance overwrites its copy when a task arrives with image set).
  String? imageUrl;

  /// Membership role (member/staff/siteAdmin — see global SiteRole).
  String roleName;

  /// Membership lifecycle (false = deactivated; local keeps the data).
  bool active;

  /// Deactivation marker of the membership (null while active).
  DateTime? endedAt;

  /// Per-(person, site) TOTP secret for door access (null for inactive
  /// memberships) — the local instance stores it on the mirror row and
  /// verifies the app-computed codes against it offline.
  String? doorCodeSecret;

  /// When the membership was created.
  DateTime? membershipCreatedAt;

  /// Returns a shallow copy of this [SiteSyncMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SiteSyncMember copyWith({
    int? taskId,
    int? profileId,
    _isc.UuidValue? globalAuthUserId,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? imageUrl,
    String? roleName,
    bool? active,
    DateTime? endedAt,
    String? doorCodeSecret,
    DateTime? membershipCreatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteSyncMember',
      'taskId': taskId,
      'profileId': profileId,
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (birthday != null) 'birthday': birthday?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'roleName': roleName,
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      if (doorCodeSecret != null) 'doorCodeSecret': doorCodeSecret,
      if (membershipCreatedAt != null)
        'membershipCreatedAt': membershipCreatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteSyncMember',
      'taskId': taskId,
      'profileId': profileId,
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (birthday != null) 'birthday': birthday?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'roleName': roleName,
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      if (doorCodeSecret != null) 'doorCodeSecret': doorCodeSecret,
      if (membershipCreatedAt != null)
        'membershipCreatedAt': membershipCreatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteSyncMemberImpl extends SiteSyncMember {
  _SiteSyncMemberImpl({
    required int taskId,
    required int profileId,
    required _isc.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? imageUrl,
    required String roleName,
    required bool active,
    DateTime? endedAt,
    String? doorCodeSecret,
    DateTime? membershipCreatedAt,
  }) : super._(
         taskId: taskId,
         profileId: profileId,
         globalAuthUserId: globalAuthUserId,
         email: email,
         firstName: firstName,
         lastName: lastName,
         birthday: birthday,
         imageUrl: imageUrl,
         roleName: roleName,
         active: active,
         endedAt: endedAt,
         doorCodeSecret: doorCodeSecret,
         membershipCreatedAt: membershipCreatedAt,
       );

  /// Returns a shallow copy of this [SiteSyncMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SiteSyncMember copyWith({
    int? taskId,
    int? profileId,
    _isc.UuidValue? globalAuthUserId,
    String? email,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
    Object? birthday = _Undefined,
    Object? imageUrl = _Undefined,
    String? roleName,
    bool? active,
    Object? endedAt = _Undefined,
    Object? doorCodeSecret = _Undefined,
    Object? membershipCreatedAt = _Undefined,
  }) {
    return SiteSyncMember(
      taskId: taskId ?? this.taskId,
      profileId: profileId ?? this.profileId,
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      email: email ?? this.email,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
      birthday: birthday is DateTime? ? birthday : this.birthday,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      roleName: roleName ?? this.roleName,
      active: active ?? this.active,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      doorCodeSecret: doorCodeSecret is String?
          ? doorCodeSecret
          : this.doorCodeSecret,
      membershipCreatedAt: membershipCreatedAt is DateTime?
          ? membershipCreatedAt
          : this.membershipCreatedAt,
    );
  }
}
