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

/// Compact policy row for lists (rules/members counts resolved).
abstract class DoorPolicySummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoorPolicySummary._({
    required this.id,
    required this.name,
    required this.ruleCount,
    required this.memberCount,
    required this.createdAt,
  });

  factory DoorPolicySummary({
    required int id,
    required String name,
    required int ruleCount,
    required int memberCount,
    required DateTime createdAt,
  }) = _DoorPolicySummaryImpl;

  factory DoorPolicySummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorPolicySummary(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      ruleCount: jsonSerialization['ruleCount'] as int,
      memberCount: jsonSerialization['memberCount'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  String name;

  int ruleCount;

  int memberCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [DoorPolicySummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoorPolicySummary copyWith({
    int? id,
    String? name,
    int? ruleCount,
    int? memberCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorPolicySummary',
      'id': id,
      'name': name,
      'ruleCount': ruleCount,
      'memberCount': memberCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorPolicySummary',
      'id': id,
      'name': name,
      'ruleCount': ruleCount,
      'memberCount': memberCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DoorPolicySummaryImpl extends DoorPolicySummary {
  _DoorPolicySummaryImpl({
    required int id,
    required String name,
    required int ruleCount,
    required int memberCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         ruleCount: ruleCount,
         memberCount: memberCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorPolicySummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoorPolicySummary copyWith({
    int? id,
    String? name,
    int? ruleCount,
    int? memberCount,
    DateTime? createdAt,
  }) {
    return DoorPolicySummary(
      id: id ?? this.id,
      name: name ?? this.name,
      ruleCount: ruleCount ?? this.ruleCount,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
