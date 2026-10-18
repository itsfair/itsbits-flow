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
import '../door/door_access_result.dart' as _i63ctnyt;

/// Audit/statistics log of every door-access verification attempt
/// (granted AND denied). This is the data basis for the later
/// per-(door, member) time-window rules and for statistics.
abstract class DoorAccessLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoorAccessLog._({
    this.id,
    this.deviceMac,
    this.userKey,
    required this.result,
    this.detail,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DoorAccessLog({
    int? id,
    String? deviceMac,
    _is.UuidValue? userKey,
    required _i63ctnyt.DoorAccessResult result,
    String? detail,
    DateTime? createdAt,
  }) = _DoorAccessLogImpl;

  factory DoorAccessLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorAccessLog(
      id: jsonSerialization['id'] as int?,
      deviceMac: jsonSerialization['deviceMac'] as String?,
      userKey: jsonSerialization['userKey'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['userKey']),
      result: _i63ctnyt.DoorAccessResult.fromJson(
        (jsonSerialization['result'] as String),
      ),
      detail: jsonSerialization['detail'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DoorAccessLogTable();

  static const db = DoorAccessLogRepository._();

  @override
  int? id;

  /// BLE MAC of the reporting device (from the verify payload); matched
  /// against door_devices.mac for attribution (informational — device
  /// authentication is a separate hardening step).
  String? deviceMac;

  /// The member the access was requested for (null for malformed
  /// requests without a parseable id).
  _is.UuidValue? userKey;

  /// Outcome of the attempt.
  _i63ctnyt.DoorAccessResult result;

  /// Optional detail (e.g. which sub-check failed internally for
  /// debugging — never surfaced to the device).
  String? detail;

  /// When the attempt happened.
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoorAccessLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorAccessLog copyWith({
    int? id,
    String? deviceMac,
    _is.UuidValue? userKey,
    _i63ctnyt.DoorAccessResult? result,
    String? detail,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorAccessLog',
      if (id != null) 'id': id,
      if (deviceMac != null) 'deviceMac': deviceMac,
      if (userKey != null) 'userKey': userKey?.toJson(),
      'result': result.toJson(),
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorAccessLog',
      if (id != null) 'id': id,
      if (deviceMac != null) 'deviceMac': deviceMac,
      if (userKey != null) 'userKey': userKey?.toJson(),
      'result': result.toJson(),
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
    };
  }

  static DoorAccessLogInclude include() {
    return DoorAccessLogInclude._();
  }

  static DoorAccessLogIncludeList includeList({
    _is.WhereExpressionBuilder<DoorAccessLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorAccessLogTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessLogTable>? orderByList,
    DoorAccessLogInclude? include,
  }) {
    return DoorAccessLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoorAccessLog.t),
      orderByList: orderByList?.call(DoorAccessLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorAccessLogImpl extends DoorAccessLog {
  _DoorAccessLogImpl({
    int? id,
    String? deviceMac,
    _is.UuidValue? userKey,
    required _i63ctnyt.DoorAccessResult result,
    String? detail,
    DateTime? createdAt,
  }) : super._(
         id: id,
         deviceMac: deviceMac,
         userKey: userKey,
         result: result,
         detail: detail,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorAccessLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorAccessLog copyWith({
    Object? id = _Undefined,
    Object? deviceMac = _Undefined,
    Object? userKey = _Undefined,
    _i63ctnyt.DoorAccessResult? result,
    Object? detail = _Undefined,
    DateTime? createdAt,
  }) {
    return DoorAccessLog(
      id: id is int? ? id : this.id,
      deviceMac: deviceMac is String? ? deviceMac : this.deviceMac,
      userKey: userKey is _is.UuidValue? ? userKey : this.userKey,
      result: result ?? this.result,
      detail: detail is String? ? detail : this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DoorAccessLogUpdateTable extends _is.UpdateTable<DoorAccessLogTable> {
  DoorAccessLogUpdateTable(super.table);

  _is.ColumnValue<String, String> deviceMac(String? value) => _is.ColumnValue(
    table.deviceMac,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userKey(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.userKey,
        value,
      );

  _is.ColumnValue<_i63ctnyt.DoorAccessResult, _i63ctnyt.DoorAccessResult>
  result(_i63ctnyt.DoorAccessResult value) => _is.ColumnValue(
    table.result,
    value,
  );

  _is.ColumnValue<String, String> detail(String? value) => _is.ColumnValue(
    table.detail,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DoorAccessLogTable extends _is.Table<int?> {
  DoorAccessLogTable({super.tableRelation})
    : super(tableName: 'door_access_logs') {
    updateTable = DoorAccessLogUpdateTable(this);
    deviceMac = _is.ColumnString(
      'deviceMac',
      this,
    );
    userKey = _is.ColumnUuid(
      'userKey',
      this,
    );
    result = _is.ColumnEnum(
      'result',
      this,
      _is.EnumSerialization.byName,
    );
    detail = _is.ColumnString(
      'detail',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DoorAccessLogUpdateTable updateTable;

  /// BLE MAC of the reporting device (from the verify payload); matched
  /// against door_devices.mac for attribution (informational — device
  /// authentication is a separate hardening step).
  late final _is.ColumnString deviceMac;

  /// The member the access was requested for (null for malformed
  /// requests without a parseable id).
  late final _is.ColumnUuid userKey;

  /// Outcome of the attempt.
  late final _is.ColumnEnum<_i63ctnyt.DoorAccessResult> result;

  /// Optional detail (e.g. which sub-check failed internally for
  /// debugging — never surfaced to the device).
  late final _is.ColumnString detail;

  /// When the attempt happened.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    deviceMac,
    userKey,
    result,
    detail,
    createdAt,
  ];
}

class DoorAccessLogInclude extends _is.IncludeObject {
  DoorAccessLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoorAccessLog.t;
}

class DoorAccessLogIncludeList extends _is.IncludeList {
  DoorAccessLogIncludeList._({
    _is.WhereExpressionBuilder<DoorAccessLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoorAccessLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoorAccessLog.t;
}

class DoorAccessLogRepository {
  const DoorAccessLogRepository._();

  /// Returns a list of [DoorAccessLog]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<DoorAccessLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorAccessLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorAccessLogTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoorAccessLog>(
      where: where?.call(DoorAccessLog.t),
      orderBy: orderBy?.call(DoorAccessLog.t),
      orderByList: orderByList?.call(DoorAccessLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoorAccessLog] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<DoorAccessLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorAccessLogTable>? where,
    int? offset,
    _is.OrderByBuilder<DoorAccessLogTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoorAccessLog>(
      where: where?.call(DoorAccessLog.t),
      orderBy: orderBy?.call(DoorAccessLog.t),
      orderByList: orderByList?.call(DoorAccessLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoorAccessLog] by its [id] or null if no such row exists.
  Future<DoorAccessLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoorAccessLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoorAccessLog]s in the list and returns the inserted rows.
  ///
  /// The returned [DoorAccessLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessLog>> insert(
    _is.DatabaseSession session,
    List<DoorAccessLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoorAccessLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoorAccessLog] and returns the inserted row.
  ///
  /// The returned [DoorAccessLog] will have its `id` field set.
  Future<DoorAccessLog> insertRow(
    _is.DatabaseSession session,
    DoorAccessLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoorAccessLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoorAccessLog]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [DoorAccessLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessLog>> upsert(
    _is.DatabaseSession session,
    List<DoorAccessLog> rows, {
    required _is.ColumnSelections<DoorAccessLogTable> conflictColumns,
    _is.ColumnSelections<DoorAccessLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DoorAccessLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoorAccessLog>(
      rows,
      conflictColumns: conflictColumns(DoorAccessLog.t),
      updateColumns: updateColumns?.call(DoorAccessLog.t),
      updateWhere: updateWhere?.call(DoorAccessLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoorAccessLog] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [DoorAccessLog] will have its `id` field set.
  Future<DoorAccessLog?> upsertRow(
    _is.DatabaseSession session,
    DoorAccessLog row, {
    required _is.ColumnSelections<DoorAccessLogTable> conflictColumns,
    _is.ColumnSelections<DoorAccessLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DoorAccessLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoorAccessLog>(
      row,
      conflictColumns: conflictColumns(DoorAccessLog.t),
      updateColumns: updateColumns?.call(DoorAccessLog.t),
      updateWhere: updateWhere?.call(DoorAccessLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoorAccessLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessLog>> update(
    _is.DatabaseSession session,
    List<DoorAccessLog> rows, {
    _is.ColumnSelections<DoorAccessLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoorAccessLog>(
      rows,
      columns: columns?.call(DoorAccessLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoorAccessLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoorAccessLog> updateRow(
    _is.DatabaseSession session,
    DoorAccessLog row, {
    _is.ColumnSelections<DoorAccessLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoorAccessLog>(
      row,
      columns: columns?.call(DoorAccessLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoorAccessLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoorAccessLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoorAccessLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoorAccessLog>(
      id,
      columnValues: columnValues(DoorAccessLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoorAccessLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoorAccessLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DoorAccessLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorAccessLogTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoorAccessLog>(
      columnValues: columnValues(DoorAccessLog.t.updateTable),
      where: where(DoorAccessLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoorAccessLog.t),
      orderByList: orderByList?.call(DoorAccessLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoorAccessLog]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessLog>> delete(
    _is.DatabaseSession session,
    List<DoorAccessLog> rows, {
    _is.OrderByBuilder<DoorAccessLogTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoorAccessLog>(
      rows,
      orderBy: orderBy?.call(DoorAccessLog.t),
      orderByList: orderByList?.call(DoorAccessLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoorAccessLog].
  Future<DoorAccessLog> deleteRow(
    _is.DatabaseSession session,
    DoorAccessLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoorAccessLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoorAccessLogTable> where,
    _is.OrderByBuilder<DoorAccessLogTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoorAccessLog>(
      where: where(DoorAccessLog.t),
      orderBy: orderBy?.call(DoorAccessLog.t),
      orderByList: orderByList?.call(DoorAccessLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorAccessLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoorAccessLog>(
      where: where?.call(DoorAccessLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoorAccessLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoorAccessLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoorAccessLog>(
      where: where(DoorAccessLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
