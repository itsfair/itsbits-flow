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

/// Single-use bookkeeping for door codes: one row per consumed
/// (person, time step). The unique index makes the consumption check
/// race-safe (insert fails => already used => deny). Old rows are
/// pruned opportunistically.
abstract class DoorAccessConsumed
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoorAccessConsumed._({
    this.id,
    required this.userKey,
    required this.step,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DoorAccessConsumed({
    int? id,
    required _isc.UuidValue userKey,
    required int step,
    DateTime? createdAt,
  }) = _DoorAccessConsumedImpl;

  factory DoorAccessConsumed.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorAccessConsumed(
      id: jsonSerialization['id'] as int?,
      userKey: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['userKey'],
      ),
      step: jsonSerialization['step'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The person the code belongs to.
  _isc.UuidValue userKey;

  /// The TOTP time step the consumed code was computed for.
  int step;

  /// When the code was consumed.
  DateTime createdAt;

  /// Returns a shallow copy of this [DoorAccessConsumed]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoorAccessConsumed copyWith({
    int? id,
    _isc.UuidValue? userKey,
    int? step,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorAccessConsumed',
      if (id != null) 'id': id,
      'userKey': userKey.toJson(),
      'step': step,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorAccessConsumed',
      if (id != null) 'id': id,
      'userKey': userKey.toJson(),
      'step': step,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorAccessConsumedImpl extends DoorAccessConsumed {
  _DoorAccessConsumedImpl({
    int? id,
    required _isc.UuidValue userKey,
    required int step,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userKey: userKey,
         step: step,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorAccessConsumed]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoorAccessConsumed copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userKey,
    int? step,
    DateTime? createdAt,
  }) {
    return DoorAccessConsumed(
      id: id is int? ? id : this.id,
      userKey: userKey ?? this.userKey,
      step: step ?? this.step,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
