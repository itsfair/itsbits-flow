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

/// One member assignment on a policy as seen by the admin UI (person
/// display fields resolved).
abstract class DoorPolicyMemberData
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DoorPolicyMemberData._({
    required this.id,
    required this.globalAuthUserId,
    required this.email,
    this.firstName,
    this.lastName,
    required this.validFrom,
    this.validUntil,
  });

  factory DoorPolicyMemberData({
    required int id,
    required _is.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    required DateTime validFrom,
    DateTime? validUntil,
  }) = _DoorPolicyMemberDataImpl;

  factory DoorPolicyMemberData.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DoorPolicyMemberData(
      id: jsonSerialization['id'] as int,
      globalAuthUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      email: jsonSerialization['email'] as String,
      firstName: jsonSerialization['firstName'] as String?,
      lastName: jsonSerialization['lastName'] as String?,
      validFrom: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['validFrom'],
      ),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
    );
  }

  int id;

  _is.UuidValue globalAuthUserId;

  String email;

  String? firstName;

  String? lastName;

  DateTime validFrom;

  DateTime? validUntil;

  /// Returns a shallow copy of this [DoorPolicyMemberData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorPolicyMemberData copyWith({
    int? id,
    _is.UuidValue? globalAuthUserId,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? validFrom,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorPolicyMemberData',
      'id': id,
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorPolicyMemberData',
      'id': id,
      'globalAuthUserId': globalAuthUserId.toJson(),
      'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorPolicyMemberDataImpl extends DoorPolicyMemberData {
  _DoorPolicyMemberDataImpl({
    required int id,
    required _is.UuidValue globalAuthUserId,
    required String email,
    String? firstName,
    String? lastName,
    required DateTime validFrom,
    DateTime? validUntil,
  }) : super._(
         id: id,
         globalAuthUserId: globalAuthUserId,
         email: email,
         firstName: firstName,
         lastName: lastName,
         validFrom: validFrom,
         validUntil: validUntil,
       );

  /// Returns a shallow copy of this [DoorPolicyMemberData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorPolicyMemberData copyWith({
    int? id,
    _is.UuidValue? globalAuthUserId,
    String? email,
    Object? firstName = _Undefined,
    Object? lastName = _Undefined,
    DateTime? validFrom,
    Object? validUntil = _Undefined,
  }) {
    return DoorPolicyMemberData(
      id: id ?? this.id,
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      email: email ?? this.email,
      firstName: firstName is String? ? firstName : this.firstName,
      lastName: lastName is String? ? lastName : this.lastName,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
    );
  }
}
