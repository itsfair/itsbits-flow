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

/// One confirmed member-data delivery (site sync at-least-once): the
/// local instance confirms a task by id + the task row's createdAt it
/// actually saw. The GLOBAL side deletes a task row only when BOTH
/// match — an enqueue that raced the pull bumped createdAt, so a stale
/// confirm never erases the newer state's marker.
abstract class SiteSyncConfirmation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SiteSyncConfirmation._({
    required this.taskId,
    required this.taskCreatedAt,
  });

  factory SiteSyncConfirmation({
    required int taskId,
    required DateTime taskCreatedAt,
  }) = _SiteSyncConfirmationImpl;

  factory SiteSyncConfirmation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SiteSyncConfirmation(
      taskId: jsonSerialization['taskId'] as int,
      taskCreatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['taskCreatedAt'],
      ),
    );
  }

  int taskId;

  DateTime taskCreatedAt;

  /// Returns a shallow copy of this [SiteSyncConfirmation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SiteSyncConfirmation copyWith({
    int? taskId,
    DateTime? taskCreatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteSyncConfirmation',
      'taskId': taskId,
      'taskCreatedAt': taskCreatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteSyncConfirmation',
      'taskId': taskId,
      'taskCreatedAt': taskCreatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SiteSyncConfirmationImpl extends SiteSyncConfirmation {
  _SiteSyncConfirmationImpl({
    required int taskId,
    required DateTime taskCreatedAt,
  }) : super._(
         taskId: taskId,
         taskCreatedAt: taskCreatedAt,
       );

  /// Returns a shallow copy of this [SiteSyncConfirmation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SiteSyncConfirmation copyWith({
    int? taskId,
    DateTime? taskCreatedAt,
  }) {
    return SiteSyncConfirmation(
      taskId: taskId ?? this.taskId,
      taskCreatedAt: taskCreatedAt ?? this.taskCreatedAt,
    );
  }
}
