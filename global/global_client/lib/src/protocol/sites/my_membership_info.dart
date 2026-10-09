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

/// The signed-in end user's membership at a site (for the subscribe state
/// and the membership screen in the end-user app). Plain-data projection —
/// the profile snapshot travels separately via `memberProfile`.
abstract class MyMembershipInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyMembershipInfo._({
    required this.siteId,
    required this.roleName,
    required this.active,
    this.endedAt,
    required this.createdAt,
  });

  factory MyMembershipInfo({
    required int siteId,
    required String roleName,
    required bool active,
    DateTime? endedAt,
    required DateTime createdAt,
  }) = _MyMembershipInfoImpl;

  factory MyMembershipInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyMembershipInfo(
      siteId: jsonSerialization['siteId'] as int,
      roleName: jsonSerialization['roleName'] as String,
      active: _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int siteId;

  String roleName;

  bool active;

  DateTime? endedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [MyMembershipInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyMembershipInfo copyWith({
    int? siteId,
    String? roleName,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyMembershipInfo',
      'siteId': siteId,
      'roleName': roleName,
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyMembershipInfo',
      'siteId': siteId,
      'roleName': roleName,
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MyMembershipInfoImpl extends MyMembershipInfo {
  _MyMembershipInfoImpl({
    required int siteId,
    required String roleName,
    required bool active,
    DateTime? endedAt,
    required DateTime createdAt,
  }) : super._(
         siteId: siteId,
         roleName: roleName,
         active: active,
         endedAt: endedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MyMembershipInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyMembershipInfo copyWith({
    int? siteId,
    String? roleName,
    bool? active,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return MyMembershipInfo(
      siteId: siteId ?? this.siteId,
      roleName: roleName ?? this.roleName,
      active: active ?? this.active,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
