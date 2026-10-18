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
import '../door/access_policy.dart' as _iesob2yd;
import '../site/member_profile.dart' as _iwun33if;

/// Assignment of one member to one access policy — with the validity
/// period PER USER (the policy itself carries no time period). Several
/// assignments (= several policies) OR-combine.
abstract class AccessPolicyMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccessPolicyMember._({
    this.id,
    required this.policyId,
    this.policy,
    required this.memberProfileId,
    this.memberProfile,
    required this.globalAuthUserId,
    DateTime? validFrom,
    this.validUntil,
  }) : validFrom = validFrom ?? DateTime.now();

  factory AccessPolicyMember({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _isc.UuidValue globalAuthUserId,
    DateTime? validFrom,
    DateTime? validUntil,
  }) = _AccessPolicyMemberImpl;

  factory AccessPolicyMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessPolicyMember(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _ioaiyikp.Protocol().deserialize<_iesob2yd.AccessPolicy>(
              jsonSerialization['policy'],
            ),
      memberProfileId: jsonSerialization['memberProfileId'] as int,
      memberProfile: jsonSerialization['memberProfile'] == null
          ? null
          : _ioaiyikp.Protocol().deserialize<_iwun33if.MemberProfile>(
              jsonSerialization['memberProfile'],
            ),
      globalAuthUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['validUntil'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int policyId;

  /// The policy being assigned.
  _iesob2yd.AccessPolicy? policy;

  int memberProfileId;

  /// The assigned person (mirror row).
  _iwun33if.MemberProfile? memberProfile;

  /// Denormalized exchange id — the verifier looks up by this (no join),
  /// same pattern as member_membership.
  _isc.UuidValue globalAuthUserId;

  /// Assignment validity start (local time; default now).
  DateTime validFrom;

  /// Assignment validity end (null = unlimited).
  DateTime? validUntil;

  /// Returns a shallow copy of this [AccessPolicyMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccessPolicyMember copyWith({
    int? id,
    int? policyId,
    _iesob2yd.AccessPolicy? policy,
    int? memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    _isc.UuidValue? globalAuthUserId,
    DateTime? validFrom,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessPolicyMember',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      'memberProfileId': memberProfileId,
      if (memberProfile != null) 'memberProfile': memberProfile?.toJson(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccessPolicyMember',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      'memberProfileId': memberProfileId,
      if (memberProfile != null)
        'memberProfile': memberProfile?.toJsonForProtocol(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessPolicyMemberImpl extends AccessPolicyMember {
  _AccessPolicyMemberImpl({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _isc.UuidValue globalAuthUserId,
    DateTime? validFrom,
    DateTime? validUntil,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         memberProfileId: memberProfileId,
         memberProfile: memberProfile,
         globalAuthUserId: globalAuthUserId,
         validFrom: validFrom,
         validUntil: validUntil,
       );

  /// Returns a shallow copy of this [AccessPolicyMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccessPolicyMember copyWith({
    Object? id = _Undefined,
    int? policyId,
    Object? policy = _Undefined,
    int? memberProfileId,
    Object? memberProfile = _Undefined,
    _isc.UuidValue? globalAuthUserId,
    DateTime? validFrom,
    Object? validUntil = _Undefined,
  }) {
    return AccessPolicyMember(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _iesob2yd.AccessPolicy?
          ? policy
          : this.policy?.copyWith(),
      memberProfileId: memberProfileId ?? this.memberProfileId,
      memberProfile: memberProfile is _iwun33if.MemberProfile?
          ? memberProfile
          : this.memberProfile?.copyWith(),
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
    );
  }
}
