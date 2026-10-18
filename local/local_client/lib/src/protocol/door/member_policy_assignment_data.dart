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

/// One member's policy assignment (member-detail view): the policy name
/// plus the per-user validity period.
abstract class MemberPolicyAssignmentData
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MemberPolicyAssignmentData._({
    required this.assignmentId,
    required this.policyId,
    required this.policyName,
    required this.validFrom,
    this.validUntil,
  });

  factory MemberPolicyAssignmentData({
    required int assignmentId,
    required int policyId,
    required String policyName,
    required DateTime validFrom,
    DateTime? validUntil,
  }) = _MemberPolicyAssignmentDataImpl;

  factory MemberPolicyAssignmentData.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MemberPolicyAssignmentData(
      assignmentId: jsonSerialization['assignmentId'] as int,
      policyId: jsonSerialization['policyId'] as int,
      policyName: jsonSerialization['policyName'] as String,
      validFrom: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['validFrom'],
      ),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['validUntil'],
            ),
    );
  }

  int assignmentId;

  int policyId;

  String policyName;

  DateTime validFrom;

  DateTime? validUntil;

  /// Returns a shallow copy of this [MemberPolicyAssignmentData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MemberPolicyAssignmentData copyWith({
    int? assignmentId,
    int? policyId,
    String? policyName,
    DateTime? validFrom,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberPolicyAssignmentData',
      'assignmentId': assignmentId,
      'policyId': policyId,
      'policyName': policyName,
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberPolicyAssignmentData',
      'assignmentId': assignmentId,
      'policyId': policyId,
      'policyName': policyName,
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

class _MemberPolicyAssignmentDataImpl extends MemberPolicyAssignmentData {
  _MemberPolicyAssignmentDataImpl({
    required int assignmentId,
    required int policyId,
    required String policyName,
    required DateTime validFrom,
    DateTime? validUntil,
  }) : super._(
         assignmentId: assignmentId,
         policyId: policyId,
         policyName: policyName,
         validFrom: validFrom,
         validUntil: validUntil,
       );

  /// Returns a shallow copy of this [MemberPolicyAssignmentData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MemberPolicyAssignmentData copyWith({
    int? assignmentId,
    int? policyId,
    String? policyName,
    DateTime? validFrom,
    Object? validUntil = _Undefined,
  }) {
    return MemberPolicyAssignmentData(
      assignmentId: assignmentId ?? this.assignmentId,
      policyId: policyId ?? this.policyId,
      policyName: policyName ?? this.policyName,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
    );
  }
}
