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

/// Row of the local member directory (member_profile mirror) for the
/// site admin UI's members list. Plain-data projection — no internals
/// (image URL included for the list card).
abstract class MemberSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MemberSummary._({
    required this.globalAuthUserId,
    required this.email,
    this.firstName,
    this.lastName,
    this.imageUrl,
    required this.hasLocalLogin,
    this.roleName,
    this.active,
    this.endedAt,
  });

  factory MemberSummary({
    required _is.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    String? imageUrl,
    required bool hasLocalLogin,
    String? roleName,
    bool? active,
    DateTime? endedAt,
  }) = _MemberSummaryImpl;

  factory MemberSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberSummary(
      globalAuthUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      email: jsonSerialization['email'] as String,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
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
    );
  }

  /// Exchange id (global authUserId = door key, also route id).
  _is.UuidValue globalAuthUserId;

  String email;

  String? firstName;

  String? lastName;

  String? imageUrl;

  /// Whether the person has a local login (site admin / staff).
  bool hasLocalLogin;

  /// Membership mirror fields (null when the person is not yet a
  /// synced member — e.g. the admin before the first sync).
  String? roleName;

  bool? active;

  DateTime? endedAt;

  /// Returns a shallow copy of this [MemberSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MemberSummary copyWith({
    _is.UuidValue? globalAuthUserId,
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
    bool? hasLocalLogin,
    String? roleName,
    bool? active,
    DateTime? endedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberSummary',
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'hasLocalLogin': hasLocalLogin,
      if (roleName != null) 'roleName': roleName,
      if (active != null) 'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberSummary',
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'hasLocalLogin': hasLocalLogin,
      if (roleName != null) 'roleName': roleName,
      if (active != null) 'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberSummaryImpl extends MemberSummary {
  _MemberSummaryImpl({
    required _is.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    String? imageUrl,
    required bool hasLocalLogin,
    String? roleName,
    bool? active,
    DateTime? endedAt,
  }) : super._(
         globalAuthUserId: globalAuthUserId,
         email: email,
         firstName: firstName,
         lastName: lastName,
         imageUrl: imageUrl,
         hasLocalLogin: hasLocalLogin,
         roleName: roleName,
         active: active,
         endedAt: endedAt,
       );

  /// Returns a shallow copy of this [MemberSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MemberSummary copyWith({
    _is.UuidValue? globalAuthUserId,
    String? email,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
    Object? imageUrl = _Undefined,
    bool? hasLocalLogin,
    Object? roleName = _Undefined,
    Object? active = _Undefined,
    Object? endedAt = _Undefined,
  }) {
    return MemberSummary(
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      email: email ?? this.email,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      hasLocalLogin: hasLocalLogin ?? this.hasLocalLogin,
      roleName: roleName is String? ? roleName : this.roleName,
      active: active is bool? ? active : this.active,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
    );
  }
}
