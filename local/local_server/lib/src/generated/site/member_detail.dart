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
import 'package:serverpod/serverpod.dart' as _is;

/// Full read-only detail of a local member (person mirror + membership
/// mirror). Editing happens globally only (sync rule).
abstract class MemberDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MemberDetail._({
    required this.globalAuthUserId,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.imageUrl,
    required this.profileCreatedAt,
    required this.hasLocalLogin,
    this.roleName,
    this.active,
    this.endedAt,
    this.membershipCreatedAt,
  });

  factory MemberDetail({
    required _is.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? imageUrl,
    required DateTime profileCreatedAt,
    required bool hasLocalLogin,
    String? roleName,
    bool? active,
    DateTime? endedAt,
    DateTime? membershipCreatedAt,
  }) = _MemberDetailImpl;

  factory MemberDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberDetail(
      globalAuthUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      email: jsonSerialization['email'] as String,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
      birthday: jsonSerialization['birthday'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['birthday']),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      profileCreatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['profileCreatedAt'],
      ),
      hasLocalLogin: _is.BoolJsonExtension.fromJson(
        jsonSerialization['hasLocalLogin'],
      ),
      roleName: jsonSerialization['roleName'] as String?,
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      membershipCreatedAt: jsonSerialization['membershipCreatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['membershipCreatedAt'],
            ),
    );
  }

  _is.UuidValue globalAuthUserId;

  String email;

  String? firstName;

  String? lastName;

  DateTime? birthday;

  String? imageUrl;

  DateTime profileCreatedAt;

  /// Whether the person has a local login (site admin / staff).
  bool hasLocalLogin;

  /// Membership mirror fields (null when not yet a synced member).
  String? roleName;

  bool? active;

  DateTime? endedAt;

  DateTime? membershipCreatedAt;

  /// Returns a shallow copy of this [MemberDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MemberDetail copyWith({
    _is.UuidValue? globalAuthUserId,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? imageUrl,
    DateTime? profileCreatedAt,
    bool? hasLocalLogin,
    String? roleName,
    bool? active,
    DateTime? endedAt,
    DateTime? membershipCreatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberDetail',
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (birthday != null) 'birthday': birthday?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'profileCreatedAt': profileCreatedAt.toJson(),
      'hasLocalLogin': hasLocalLogin,
      if (roleName != null) 'roleName': roleName,
      if (active != null) 'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      if (membershipCreatedAt != null)
        'membershipCreatedAt': membershipCreatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberDetail',
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (birthday != null) 'birthday': birthday?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'profileCreatedAt': profileCreatedAt.toJson(),
      'hasLocalLogin': hasLocalLogin,
      if (roleName != null) 'roleName': roleName,
      if (active != null) 'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      if (membershipCreatedAt != null)
        'membershipCreatedAt': membershipCreatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberDetailImpl extends MemberDetail {
  _MemberDetailImpl({
    required _is.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? imageUrl,
    required DateTime profileCreatedAt,
    required bool hasLocalLogin,
    String? roleName,
    bool? active,
    DateTime? endedAt,
    DateTime? membershipCreatedAt,
  }) : super._(
         globalAuthUserId: globalAuthUserId,
         email: email,
         firstName: firstName,
         lastName: lastName,
         birthday: birthday,
         imageUrl: imageUrl,
         profileCreatedAt: profileCreatedAt,
         hasLocalLogin: hasLocalLogin,
         roleName: roleName,
         active: active,
         endedAt: endedAt,
         membershipCreatedAt: membershipCreatedAt,
       );

  /// Returns a shallow copy of this [MemberDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MemberDetail copyWith({
    _is.UuidValue? globalAuthUserId,
    String? email,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
    Object? birthday = _Undefined,
    Object? imageUrl = _Undefined,
    DateTime? profileCreatedAt,
    bool? hasLocalLogin,
    Object? roleName = _Undefined,
    Object? active = _Undefined,
    Object? endedAt = _Undefined,
    Object? membershipCreatedAt = _Undefined,
  }) {
    return MemberDetail(
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      email: email ?? this.email,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
      birthday: birthday is DateTime? ? birthday : this.birthday,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      profileCreatedAt: profileCreatedAt ?? this.profileCreatedAt,
      hasLocalLogin: hasLocalLogin ?? this.hasLocalLogin,
      roleName: roleName is String? ? roleName : this.roleName,
      active: active is bool? ? active : this.active,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      membershipCreatedAt: membershipCreatedAt is DateTime?
          ? membershipCreatedAt
          : this.membershipCreatedAt,
    );
  }
}
