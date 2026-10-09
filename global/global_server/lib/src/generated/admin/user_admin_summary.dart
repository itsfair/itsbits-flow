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
import 'package:global_server/src/generated/protocol.dart' as _i8hp6qz9;
import 'package:serverpod/serverpod.dart' as _is;

/// A single user as shown/edited in the global admin UI.
abstract class AdminUserSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUserSummary._({
    required this.authUserId,
    required this.email,
    this.firstName,
    this.lastName,
    required this.scopeNames,
    required this.blocked,
    required this.createdAt,
  });

  factory AdminUserSummary({
    required _is.UuidValue authUserId,
    required String email,
    String? firstName,
    String? lastName,
    required List<String> scopeNames,
    required bool blocked,
    required DateTime createdAt,
  }) = _AdminUserSummaryImpl;

  factory AdminUserSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserSummary(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      email: jsonSerialization['email'] as String,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
      scopeNames: _i8hp6qz9.Protocol().deserialize<List<String>>(
        jsonSerialization['scopeNames'],
      ),
      blocked: _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The auth user id (userIdentifier of the authentication system).
  _is.UuidValue authUserId;

  /// Lowercase e-mail address (duplicate from the registration, see
  /// member_profile).
  String email;

  /// Profile data (own member_profile model — not the built-in Serverpod
  /// UserProfile feature, which is bypassed).
  String? firstName;

  String? lastName;

  /// The scopes assigned to this user (e.g. 'global-admin').
  List<String> scopeNames;

  /// Whether the user is blocked from signing in.
  bool blocked;

  /// When the user account was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [AdminUserSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUserSummary copyWith({
    _is.UuidValue? authUserId,
    String? email,
    String? firstName,
    String? lastName,
    List<String>? scopeNames,
    bool? blocked,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserSummary',
      'authUserId': authUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserSummary',
      'authUserId': authUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'scopeNames': scopeNames.toJson(),
      'blocked': blocked,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserSummaryImpl extends AdminUserSummary {
  _AdminUserSummaryImpl({
    required _is.UuidValue authUserId,
    required String email,
    String? firstName,
    String? lastName,
    required List<String> scopeNames,
    required bool blocked,
    required DateTime createdAt,
  }) : super._(
         authUserId: authUserId,
         email: email,
         firstName: firstName,
         lastName: lastName,
         scopeNames: scopeNames,
         blocked: blocked,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminUserSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUserSummary copyWith({
    _is.UuidValue? authUserId,
    String? email,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
    List<String>? scopeNames,
    bool? blocked,
    DateTime? createdAt,
  }) {
    return AdminUserSummary(
      authUserId: authUserId ?? this.authUserId,
      email: email ?? this.email,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toList(),
      blocked: blocked ?? this.blocked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
