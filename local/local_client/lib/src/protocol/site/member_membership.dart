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
import 'package:local_client/src/protocol/protocol.dart' as _ioaiyikp;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../site/member_profile.dart' as _iwun33if;
import '../site/member_role.dart' as _iampahbt;

/// Local mirror of a global site membership (role/active bookkeeping —
/// root-AGENTS open item). Deactivation sets `active=false` + `endedAt`;
/// the person rows are KEPT so the site can still view its members.
/// Staff/admin roles later switch the local login behavior (employees
/// flow) — that mapping is implemented with the employees feature.
abstract class MemberMembership
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MemberMembership._({
    this.id,
    required this.memberProfileId,
    this.memberProfile,
    required this.globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    this.endedAt,
    DateTime? createdAt,
  }) : role = role ?? _iampahbt.MemberRole.member,
       active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory MemberMembership({
    int? id,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _isc.UuidValue globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  }) = _MemberMembershipImpl;

  factory MemberMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberMembership(
      id: jsonSerialization['id'] as int?,
      memberProfileId: jsonSerialization['memberProfileId'] as int,
      memberProfile: jsonSerialization['memberProfile'] == null
          ? null
          : _ioaiyikp.Protocol().deserialize<_iwun33if.MemberProfile>(
              jsonSerialization['memberProfile'],
            ),
      globalAuthUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      role: jsonSerialization['role'] == null
          ? null
          : _iampahbt.MemberRole.fromJson(
              (jsonSerialization['role'] as String),
            ),
      active: jsonSerialization['active'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int memberProfileId;

  /// The local member_profile copy this membership belongs to.
  _iwun33if.MemberProfile? memberProfile;

  /// Denormalized exchange id (same as the profile's globalAuthUserId).
  _isc.UuidValue globalAuthUserId;

  /// Mirror of the global SiteRole.
  _iampahbt.MemberRole role;

  /// Lifecycle mirror (false = deactivated; data kept).
  bool active;

  /// Deactivation marker (null while active).
  DateTime? endedAt;

  /// When the membership known to this instance was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [MemberMembership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MemberMembership copyWith({
    int? id,
    int? memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    _isc.UuidValue? globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberMembership',
      if (id != null) 'id': id,
      'memberProfileId': memberProfileId,
      if (memberProfile != null) 'memberProfile': memberProfile?.toJson(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'role': role.toJson(),
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberMembership',
      if (id != null) 'id': id,
      'memberProfileId': memberProfileId,
      if (memberProfile != null)
        'memberProfile': memberProfile?.toJsonForProtocol(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'role': role.toJson(),
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

class _MemberMembershipImpl extends MemberMembership {
  _MemberMembershipImpl({
    int? id,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _isc.UuidValue globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         memberProfileId: memberProfileId,
         memberProfile: memberProfile,
         globalAuthUserId: globalAuthUserId,
         role: role,
         active: active,
         endedAt: endedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MemberMembership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MemberMembership copyWith({
    Object? id = _Undefined,
    int? memberProfileId,
    Object? memberProfile = _Undefined,
    _isc.UuidValue? globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return MemberMembership(
      id: id is int? ? id : this.id,
      memberProfileId: memberProfileId ?? this.memberProfileId,
      memberProfile: memberProfile is _iwun33if.MemberProfile?
          ? memberProfile
          : this.memberProfile?.copyWith(),
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      role: role ?? this.role,
      active: active ?? this.active,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
