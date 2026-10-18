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
import '../door/door_policy_member_data.dart' as _ij0uq44f;
import '../door/door_policy_rule_data.dart' as _i3l5ue5c;

/// Full policy detail for the admin editor (rules + member assignments).
abstract class DoorPolicyDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoorPolicyDetail._({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.rules,
    required this.members,
  });

  factory DoorPolicyDetail({
    required int id,
    required String name,
    required DateTime createdAt,
    required List<_i3l5ue5c.DoorPolicyRuleData> rules,
    required List<_ij0uq44f.DoorPolicyMemberData> members,
  }) = _DoorPolicyDetailImpl;

  factory DoorPolicyDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorPolicyDetail(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      rules: _ioaiyikp.Protocol()
          .deserialize<List<_i3l5ue5c.DoorPolicyRuleData>>(
            jsonSerialization['rules'],
          ),
      members: _ioaiyikp.Protocol()
          .deserialize<List<_ij0uq44f.DoorPolicyMemberData>>(
            jsonSerialization['members'],
          ),
    );
  }

  int id;

  String name;

  DateTime createdAt;

  List<_i3l5ue5c.DoorPolicyRuleData> rules;

  List<_ij0uq44f.DoorPolicyMemberData> members;

  /// Returns a shallow copy of this [DoorPolicyDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoorPolicyDetail copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    List<_i3l5ue5c.DoorPolicyRuleData>? rules,
    List<_ij0uq44f.DoorPolicyMemberData>? members,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorPolicyDetail',
      'id': id,
      'name': name,
      'createdAt': createdAt.toJson(),
      'rules': rules.toJson(valueToJson: (v) => v.toJson()),
      'members': members.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorPolicyDetail',
      'id': id,
      'name': name,
      'createdAt': createdAt.toJson(),
      'rules': rules.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'members': members.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DoorPolicyDetailImpl extends DoorPolicyDetail {
  _DoorPolicyDetailImpl({
    required int id,
    required String name,
    required DateTime createdAt,
    required List<_i3l5ue5c.DoorPolicyRuleData> rules,
    required List<_ij0uq44f.DoorPolicyMemberData> members,
  }) : super._(
         id: id,
         name: name,
         createdAt: createdAt,
         rules: rules,
         members: members,
       );

  /// Returns a shallow copy of this [DoorPolicyDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoorPolicyDetail copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    List<_i3l5ue5c.DoorPolicyRuleData>? rules,
    List<_ij0uq44f.DoorPolicyMemberData>? members,
  }) {
    return DoorPolicyDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rules: rules ?? this.rules.map((e0) => e0.copyWith()).toList(),
      members: members ?? this.members.map((e0) => e0.copyWith()).toList(),
    );
  }
}
