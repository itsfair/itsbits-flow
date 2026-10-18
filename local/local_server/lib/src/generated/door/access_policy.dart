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

/// One access policy ("Zugangsberechtigung"): a named BUNDLE of
/// door/weekday/time rules plus member assignments. Deny-by-default:
/// without an active assignment a member cannot open any door.
abstract class AccessPolicy
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AccessPolicyTable();

  static const db = AccessPolicyRepository._();

  @override
  int? id;

  /// Display name (e.g. "Kurs Yoga Mo 17-19" or "Hausmeister").
  String name;

  /// When the policy was created.
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccessPolicy]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static AccessPolicyInclude include() {
    return AccessPolicyInclude._();
  }

  static AccessPolicyIncludeList includeList({
    _is.WhereExpressionBuilder<AccessPolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyTable>? orderByList,
    AccessPolicyInclude? include,
  }) {
    return AccessPolicyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessPolicy.t),
      orderByList: orderByList?.call(AccessPolicy.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class AccessPolicyUpdateTable extends _is.UpdateTable<AccessPolicyTable> {
  AccessPolicyUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AccessPolicyTable extends _is.Table<int?> {
  AccessPolicyTable({super.tableRelation})
    : super(tableName: 'access_policies') {
    updateTable = AccessPolicyUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AccessPolicyUpdateTable updateTable;

  /// Display name (e.g. "Kurs Yoga Mo 17-19" or "Hausmeister").
  late final _is.ColumnString name;

  /// When the policy was created.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    createdAt,
  ];
}

class AccessPolicyInclude extends _is.IncludeObject {
  AccessPolicyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AccessPolicy.t;
}

class AccessPolicyIncludeList extends _is.IncludeList {
  AccessPolicyIncludeList._({
    _is.WhereExpressionBuilder<AccessPolicyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccessPolicy.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AccessPolicy.t;
}

class AccessPolicyRepository {
  const AccessPolicyRepository._();

  /// Returns a list of [AccessPolicy]s matching the given query parameters.
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
  Future<List<AccessPolicy>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccessPolicy>(
      where: where?.call(AccessPolicy.t),
      orderBy: orderBy?.call(AccessPolicy.t),
      orderByList: orderByList?.call(AccessPolicy.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccessPolicy] matching the given query parameters.
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
  Future<AccessPolicy?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyTable>? where,
    int? offset,
    _is.OrderByBuilder<AccessPolicyTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccessPolicy>(
      where: where?.call(AccessPolicy.t),
      orderBy: orderBy?.call(AccessPolicy.t),
      orderByList: orderByList?.call(AccessPolicy.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccessPolicy] by its [id] or null if no such row exists.
  Future<AccessPolicy?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccessPolicy>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccessPolicy]s in the list and returns the inserted rows.
  ///
  /// The returned [AccessPolicy]s will have their `id` fields set.
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
  Future<List<AccessPolicy>> insert(
    _is.DatabaseSession session,
    List<AccessPolicy> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccessPolicy>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccessPolicy] and returns the inserted row.
  ///
  /// The returned [AccessPolicy] will have its `id` field set.
  Future<AccessPolicy> insertRow(
    _is.DatabaseSession session,
    AccessPolicy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccessPolicy>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccessPolicy]s in the list and returns the resulting rows.
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
  /// The returned [AccessPolicy]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicy>> upsert(
    _is.DatabaseSession session,
    List<AccessPolicy> rows, {
    required _is.ColumnSelections<AccessPolicyTable> conflictColumns,
    _is.ColumnSelections<AccessPolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessPolicyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccessPolicy>(
      rows,
      conflictColumns: conflictColumns(AccessPolicy.t),
      updateColumns: updateColumns?.call(AccessPolicy.t),
      updateWhere: updateWhere?.call(AccessPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccessPolicy] and returns the resulting row.
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
  /// The returned [AccessPolicy] will have its `id` field set.
  Future<AccessPolicy?> upsertRow(
    _is.DatabaseSession session,
    AccessPolicy row, {
    required _is.ColumnSelections<AccessPolicyTable> conflictColumns,
    _is.ColumnSelections<AccessPolicyTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessPolicyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccessPolicy>(
      row,
      conflictColumns: conflictColumns(AccessPolicy.t),
      updateColumns: updateColumns?.call(AccessPolicy.t),
      updateWhere: updateWhere?.call(AccessPolicy.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccessPolicy]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicy>> update(
    _is.DatabaseSession session,
    List<AccessPolicy> rows, {
    _is.ColumnSelections<AccessPolicyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccessPolicy>(
      rows,
      columns: columns?.call(AccessPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccessPolicy]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccessPolicy> updateRow(
    _is.DatabaseSession session,
    AccessPolicy row, {
    _is.ColumnSelections<AccessPolicyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccessPolicy>(
      row,
      columns: columns?.call(AccessPolicy.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccessPolicy] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccessPolicy?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AccessPolicyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccessPolicy>(
      id,
      columnValues: columnValues(AccessPolicy.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccessPolicy]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicy>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccessPolicyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AccessPolicyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccessPolicy>(
      columnValues: columnValues(AccessPolicy.t.updateTable),
      where: where(AccessPolicy.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessPolicy.t),
      orderByList: orderByList?.call(AccessPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccessPolicy]s in the list and returns the deleted rows.
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
  Future<List<AccessPolicy>> delete(
    _is.DatabaseSession session,
    List<AccessPolicy> rows, {
    _is.OrderByBuilder<AccessPolicyTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccessPolicy>(
      rows,
      orderBy: orderBy?.call(AccessPolicy.t),
      orderByList: orderByList?.call(AccessPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccessPolicy].
  Future<AccessPolicy> deleteRow(
    _is.DatabaseSession session,
    AccessPolicy row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccessPolicy>(
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
  Future<List<AccessPolicy>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessPolicyTable> where,
    _is.OrderByBuilder<AccessPolicyTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccessPolicy>(
      where: where(AccessPolicy.t),
      orderBy: orderBy?.call(AccessPolicy.t),
      orderByList: orderByList?.call(AccessPolicy.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccessPolicy>(
      where: where?.call(AccessPolicy.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccessPolicy] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessPolicyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccessPolicy>(
      where: where(AccessPolicy.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
