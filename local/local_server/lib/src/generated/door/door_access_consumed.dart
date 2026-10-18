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

/// Single-use bookkeeping for door codes: one row per consumed
/// (person, request timestamp). The unique index makes the consumption
/// check race-safe (insert fails => already used => deny). Old rows are
/// pruned opportunistically (~15 min retention).
abstract class DoorAccessConsumed
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoorAccessConsumed._({
    this.id,
    required this.userKey,
    required this.timestampMs,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DoorAccessConsumed({
    int? id,
    required _is.UuidValue userKey,
    required int timestampMs,
    DateTime? createdAt,
  }) = _DoorAccessConsumedImpl;

  factory DoorAccessConsumed.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorAccessConsumed(
      id: jsonSerialization['id'] as int?,
      userKey: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['userKey'],
      ),
      timestampMs: jsonSerialization['timestampMs'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DoorAccessConsumedTable();

  static const db = DoorAccessConsumedRepository._();

  @override
  int? id;

  /// The person the code belongs to.
  _is.UuidValue userKey;

  /// The millisecond timestamp the consumed code was computed for
  /// (each request computes its own code from a fresh timestamp).
  int timestampMs;

  /// When the code was consumed.
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoorAccessConsumed]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorAccessConsumed copyWith({
    int? id,
    _is.UuidValue? userKey,
    int? timestampMs,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorAccessConsumed',
      if (id != null) 'id': id,
      'userKey': userKey.toJson(),
      'timestampMs': timestampMs,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorAccessConsumed',
      if (id != null) 'id': id,
      'userKey': userKey.toJson(),
      'timestampMs': timestampMs,
      'createdAt': createdAt.toJson(),
    };
  }

  static DoorAccessConsumedInclude include() {
    return DoorAccessConsumedInclude._();
  }

  static DoorAccessConsumedIncludeList includeList({
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorAccessConsumedTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessConsumedTable>? orderByList,
    DoorAccessConsumedInclude? include,
  }) {
    return DoorAccessConsumedIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoorAccessConsumed.t),
      orderByList: orderByList?.call(DoorAccessConsumed.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorAccessConsumedImpl extends DoorAccessConsumed {
  _DoorAccessConsumedImpl({
    int? id,
    required _is.UuidValue userKey,
    required int timestampMs,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userKey: userKey,
         timestampMs: timestampMs,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorAccessConsumed]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorAccessConsumed copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userKey,
    int? timestampMs,
    DateTime? createdAt,
  }) {
    return DoorAccessConsumed(
      id: id is int? ? id : this.id,
      userKey: userKey ?? this.userKey,
      timestampMs: timestampMs ?? this.timestampMs,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DoorAccessConsumedUpdateTable
    extends _is.UpdateTable<DoorAccessConsumedTable> {
  DoorAccessConsumedUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userKey(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userKey,
        value,
      );

  _is.ColumnValue<int, int> timestampMs(int value) => _is.ColumnValue(
    table.timestampMs,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DoorAccessConsumedTable extends _is.Table<int?> {
  DoorAccessConsumedTable({super.tableRelation})
    : super(tableName: 'door_access_consumed') {
    updateTable = DoorAccessConsumedUpdateTable(this);
    userKey = _is.ColumnUuid(
      'userKey',
      this,
    );
    timestampMs = _is.ColumnInt(
      'timestampMs',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DoorAccessConsumedUpdateTable updateTable;

  /// The person the code belongs to.
  late final _is.ColumnUuid userKey;

  /// The millisecond timestamp the consumed code was computed for
  /// (each request computes its own code from a fresh timestamp).
  late final _is.ColumnInt timestampMs;

  /// When the code was consumed.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userKey,
    timestampMs,
    createdAt,
  ];
}

class DoorAccessConsumedInclude extends _is.IncludeObject {
  DoorAccessConsumedInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoorAccessConsumed.t;
}

class DoorAccessConsumedIncludeList extends _is.IncludeList {
  DoorAccessConsumedIncludeList._({
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoorAccessConsumed.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoorAccessConsumed.t;
}

class DoorAccessConsumedRepository {
  const DoorAccessConsumedRepository._();

  /// Returns a list of [DoorAccessConsumed]s matching the given query parameters.
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
  Future<List<DoorAccessConsumed>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorAccessConsumedTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessConsumedTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoorAccessConsumed>(
      where: where?.call(DoorAccessConsumed.t),
      orderBy: orderBy?.call(DoorAccessConsumed.t),
      orderByList: orderByList?.call(DoorAccessConsumed.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoorAccessConsumed] matching the given query parameters.
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
  Future<DoorAccessConsumed?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? where,
    int? offset,
    _is.OrderByBuilder<DoorAccessConsumedTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessConsumedTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoorAccessConsumed>(
      where: where?.call(DoorAccessConsumed.t),
      orderBy: orderBy?.call(DoorAccessConsumed.t),
      orderByList: orderByList?.call(DoorAccessConsumed.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoorAccessConsumed] by its [id] or null if no such row exists.
  Future<DoorAccessConsumed?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoorAccessConsumed>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoorAccessConsumed]s in the list and returns the inserted rows.
  ///
  /// The returned [DoorAccessConsumed]s will have their `id` fields set.
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
  Future<List<DoorAccessConsumed>> insert(
    _is.DatabaseSession session,
    List<DoorAccessConsumed> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoorAccessConsumed>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoorAccessConsumed] and returns the inserted row.
  ///
  /// The returned [DoorAccessConsumed] will have its `id` field set.
  Future<DoorAccessConsumed> insertRow(
    _is.DatabaseSession session,
    DoorAccessConsumed row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoorAccessConsumed>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoorAccessConsumed]s in the list and returns the resulting rows.
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
  /// The returned [DoorAccessConsumed]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessConsumed>> upsert(
    _is.DatabaseSession session,
    List<DoorAccessConsumed> rows, {
    required _is.ColumnSelections<DoorAccessConsumedTable> conflictColumns,
    _is.ColumnSelections<DoorAccessConsumedTable>? updateColumns,
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoorAccessConsumed>(
      rows,
      conflictColumns: conflictColumns(DoorAccessConsumed.t),
      updateColumns: updateColumns?.call(DoorAccessConsumed.t),
      updateWhere: updateWhere?.call(DoorAccessConsumed.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoorAccessConsumed] and returns the resulting row.
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
  /// The returned [DoorAccessConsumed] will have its `id` field set.
  Future<DoorAccessConsumed?> upsertRow(
    _is.DatabaseSession session,
    DoorAccessConsumed row, {
    required _is.ColumnSelections<DoorAccessConsumedTable> conflictColumns,
    _is.ColumnSelections<DoorAccessConsumedTable>? updateColumns,
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoorAccessConsumed>(
      row,
      conflictColumns: conflictColumns(DoorAccessConsumed.t),
      updateColumns: updateColumns?.call(DoorAccessConsumed.t),
      updateWhere: updateWhere?.call(DoorAccessConsumed.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoorAccessConsumed]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessConsumed>> update(
    _is.DatabaseSession session,
    List<DoorAccessConsumed> rows, {
    _is.ColumnSelections<DoorAccessConsumedTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoorAccessConsumed>(
      rows,
      columns: columns?.call(DoorAccessConsumed.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoorAccessConsumed]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoorAccessConsumed> updateRow(
    _is.DatabaseSession session,
    DoorAccessConsumed row, {
    _is.ColumnSelections<DoorAccessConsumedTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoorAccessConsumed>(
      row,
      columns: columns?.call(DoorAccessConsumed.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoorAccessConsumed] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoorAccessConsumed?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoorAccessConsumedUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoorAccessConsumed>(
      id,
      columnValues: columnValues(DoorAccessConsumed.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoorAccessConsumed]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorAccessConsumed>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoorAccessConsumedUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DoorAccessConsumedTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorAccessConsumedTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessConsumedTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoorAccessConsumed>(
      columnValues: columnValues(DoorAccessConsumed.t.updateTable),
      where: where(DoorAccessConsumed.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoorAccessConsumed.t),
      orderByList: orderByList?.call(DoorAccessConsumed.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoorAccessConsumed]s in the list and returns the deleted rows.
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
  Future<List<DoorAccessConsumed>> delete(
    _is.DatabaseSession session,
    List<DoorAccessConsumed> rows, {
    _is.OrderByBuilder<DoorAccessConsumedTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessConsumedTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoorAccessConsumed>(
      rows,
      orderBy: orderBy?.call(DoorAccessConsumed.t),
      orderByList: orderByList?.call(DoorAccessConsumed.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoorAccessConsumed].
  Future<DoorAccessConsumed> deleteRow(
    _is.DatabaseSession session,
    DoorAccessConsumed row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoorAccessConsumed>(
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
  Future<List<DoorAccessConsumed>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoorAccessConsumedTable> where,
    _is.OrderByBuilder<DoorAccessConsumedTable>? orderBy,
    _is.OrderByListBuilder<DoorAccessConsumedTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoorAccessConsumed>(
      where: where(DoorAccessConsumed.t),
      orderBy: orderBy?.call(DoorAccessConsumed.t),
      orderByList: orderByList?.call(DoorAccessConsumed.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorAccessConsumedTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoorAccessConsumed>(
      where: where?.call(DoorAccessConsumed.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoorAccessConsumed] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoorAccessConsumedTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoorAccessConsumed>(
      where: where(DoorAccessConsumed.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
