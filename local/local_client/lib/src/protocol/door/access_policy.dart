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

/// One access policy ("Zugangsberechtigung"): a named BUNDLE of
/// door/weekday/time rules plus member assignments. Deny-by-default:
/// without an active assignment a member cannot open any door.
abstract class AccessPolicy
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AccessPolicy._({
    this.id,
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AccessPolicy({
    int? id,
    required String name,
    DateTime? createdAt,
  }) = _AccessPolicyImpl;

  factory AccessPolicy.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessPolicy(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Display name (e.g. "Kurs Yoga Mo 17-19" or "Hausmeister").
  String name;

  /// When the policy was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [AccessPolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccessPolicy copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessPolicy',
      if (id != null) 'id': id,
      'name': name,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccessPolicy',
      if (id != null) 'id': id,
      'name': name,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessPolicyImpl extends AccessPolicy {
  _AccessPolicyImpl({
    int? id,
    required String name,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AccessPolicy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccessPolicy copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? createdAt,
  }) {
    return AccessPolicy(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
