/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:global_server/src/generated/protocol.dart' as _i8hp6qz9;
import 'package:serverpod/serverpod.dart' as _is;
import '../profile/member_profile.dart' as _ieelrt66;
import '../sites/site.dart' as _ie3onmsc;

/// One pending member-data delivery to a site's local instance. Written
/// ALWAYS first (queue is the source of truth); a connected site is
/// additionally kicked over its method stream so it pulls immediately.
/// The pull response assembles the CURRENT global state (profile fields,
/// role, active) from the live database, so entries for the same
/// person+site collapse via the unique index — no per-change history.
/// Rows are deleted only after the local instance confirmed processing
/// (no lost updates when the site dies mid-transfer).
abstract class SiteSyncTask
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SiteSyncTask._({
    this.id,
    required this.siteId,
    this.site,
    required this.profileId,
    this.profile,
    int? attempts,
    this.lastError,
    DateTime? createdAt,
  }) : attempts = attempts ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory SiteSyncTask({
    int? id,
    required int siteId,
    _ie3onmsc.Site? site,
    required int profileId,
    _ieelrt66.MemberProfile? profile,
    int? attempts,
    String? lastError,
    DateTime? createdAt,
  }) = _SiteSyncTaskImpl;

  factory SiteSyncTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return SiteSyncTask(
      id: jsonSerialization['id'] as int?,
      siteId: jsonSerialization['siteId'] as int,
      site: jsonSerialization['site'] == null
          ? null
          : _i8hp6qz9.Protocol().deserialize<_ie3onmsc.Site>(
              jsonSerialization['site'],
            ),
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i8hp6qz9.Protocol().deserialize<_ieelrt66.MemberProfile>(
              jsonSerialization['profile'],
            ),
      attempts: jsonSerialization['attempts'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SiteSyncTaskTable();

  static const db = SiteSyncTaskRepository._();

  @override
  int? id;

  int siteId;

  /// The site the data must be delivered to.
  _ie3onmsc.Site? site;

  int profileId;

  /// The person whose profile/membership changed.
  _ieelrt66.MemberProfile? profile;

  /// Delivery attempts so far (capped; keeps the row on failure).
  int attempts;

  /// Last delivery error (processing/diagnostics).
  String? lastError;

  /// When the pending delivery was noted (refreshed on collapse).
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SiteSyncTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SiteSyncTask copyWith({
    int? id,
    int? siteId,
    _ie3onmsc.Site? site,
    int? profileId,
    _ieelrt66.MemberProfile? profile,
    int? attempts,
    String? lastError,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SiteSyncTask',
      if (id != null) 'id': id,
      'siteId': siteId,
      if (site != null) 'site': site?.toJson(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SiteSyncTask',
      if (id != null) 'id': id,
      'siteId': siteId,
      if (site != null) 'site': site?.toJsonForProtocol(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
      'attempts': attempts,
      if (lastError != null) 'lastError': lastError,
      'createdAt': createdAt.toJson(),
    };
  }

  static SiteSyncTaskInclude include({
    _ie3onmsc.SiteInclude? site,
    _ieelrt66.MemberProfileInclude? profile,
  }) {
    return SiteSyncTaskInclude._(
      site: site,
      profile: profile,
    );
  }

  static SiteSyncTaskIncludeList includeList({
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSyncTaskTable>? orderBy,
    _is.OrderByListBuilder<SiteSyncTaskTable>? orderByList,
    SiteSyncTaskInclude? include,
  }) {
    return SiteSyncTaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteSyncTask.t),
      orderByList: orderByList?.call(SiteSyncTask.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SiteSyncTaskImpl extends SiteSyncTask {
  _SiteSyncTaskImpl({
    int? id,
    required int siteId,
    _ie3onmsc.Site? site,
    required int profileId,
    _ieelrt66.MemberProfile? profile,
    int? attempts,
    String? lastError,
    DateTime? createdAt,
  }) : super._(
         id: id,
         siteId: siteId,
         site: site,
         profileId: profileId,
         profile: profile,
         attempts: attempts,
         lastError: lastError,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SiteSyncTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SiteSyncTask copyWith({
    Object? id = _Undefined,
    int? siteId,
    Object? site = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    int? attempts,
    Object? lastError = _Undefined,
    DateTime? createdAt,
  }) {
    return SiteSyncTask(
      id: id is int? ? id : this.id,
      siteId: siteId ?? this.siteId,
      site: site is _ie3onmsc.Site? ? site : this.site?.copyWith(),
      profileId: profileId ?? this.profileId,
      profile: profile is _ieelrt66.MemberProfile?
          ? profile
          : this.profile?.copyWith(),
      attempts: attempts ?? this.attempts,
      lastError: lastError is String? ? lastError : this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SiteSyncTaskUpdateTable extends _is.UpdateTable<SiteSyncTaskTable> {
  SiteSyncTaskUpdateTable(super.table);

  _is.ColumnValue<int, int> siteId(int value) => _is.ColumnValue(
    table.siteId,
    value,
  );

  _is.ColumnValue<int, int> profileId(int value) => _is.ColumnValue(
    table.profileId,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<String, String> lastError(String? value) => _is.ColumnValue(
    table.lastError,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SiteSyncTaskTable extends _is.Table<int?> {
  SiteSyncTaskTable({super.tableRelation})
    : super(tableName: 'site_sync_tasks') {
    updateTable = SiteSyncTaskUpdateTable(this);
    siteId = _is.ColumnInt(
      'siteId',
      this,
    );
    profileId = _is.ColumnInt(
      'profileId',
      this,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
    );
    lastError = _is.ColumnString(
      'lastError',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SiteSyncTaskUpdateTable updateTable;

  late final _is.ColumnInt siteId;

  /// The site the data must be delivered to.
  _ie3onmsc.SiteTable? _site;

  late final _is.ColumnInt profileId;

  /// The person whose profile/membership changed.
  _ieelrt66.MemberProfileTable? _profile;

  /// Delivery attempts so far (capped; keeps the row on failure).
  late final _is.ColumnInt attempts;

  /// Last delivery error (processing/diagnostics).
  late final _is.ColumnString lastError;

  /// When the pending delivery was noted (refreshed on collapse).
  late final _is.ColumnDateTime createdAt;

  _ie3onmsc.SiteTable get site {
    if (_site != null) return _site!;
    _site = _is.createRelationTable(
      relationFieldName: 'site',
      field: SiteSyncTask.t.siteId,
      foreignField: _ie3onmsc.Site.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ie3onmsc.SiteTable(tableRelation: foreignTableRelation),
    );
    return _site!;
  }

  _ieelrt66.MemberProfileTable get profile {
    if (_profile != null) return _profile!;
    _profile = _is.createRelationTable(
      relationFieldName: 'profile',
      field: SiteSyncTask.t.profileId,
      foreignField: _ieelrt66.MemberProfile.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ieelrt66.MemberProfileTable(tableRelation: foreignTableRelation),
    );
    return _profile!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    siteId,
    profileId,
    attempts,
    lastError,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'site') {
      return site;
    }
    if (relationField == 'profile') {
      return profile;
    }
    return null;
  }
}

class SiteSyncTaskInclude extends _is.IncludeObject {
  SiteSyncTaskInclude._({
    _ie3onmsc.SiteInclude? site,
    _ieelrt66.MemberProfileInclude? profile,
  }) {
    _site = site;
    _profile = profile;
  }

  _ie3onmsc.SiteInclude? _site;

  _ieelrt66.MemberProfileInclude? _profile;

  @override
  Map<String, _is.Include?> get includes => {
    'site': _site,
    'profile': _profile,
  };

  @override
  _is.Table<int?> get table => SiteSyncTask.t;
}

class SiteSyncTaskIncludeList extends _is.IncludeList {
  SiteSyncTaskIncludeList._({
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SiteSyncTask.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SiteSyncTask.t;
}

class SiteSyncTaskRepository {
  const SiteSyncTaskRepository._();

  final attachRow = const SiteSyncTaskAttachRowRepository._();

  /// Returns a list of [SiteSyncTask]s matching the given query parameters.
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
  Future<List<SiteSyncTask>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSyncTaskTable>? orderBy,
    _is.OrderByListBuilder<SiteSyncTaskTable>? orderByList,
    _is.Transaction? transaction,
    SiteSyncTaskInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SiteSyncTask>(
      where: where?.call(SiteSyncTask.t),
      orderBy: orderBy?.call(SiteSyncTask.t),
      orderByList: orderByList?.call(SiteSyncTask.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SiteSyncTask] matching the given query parameters.
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
  Future<SiteSyncTask?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? where,
    int? offset,
    _is.OrderByBuilder<SiteSyncTaskTable>? orderBy,
    _is.OrderByListBuilder<SiteSyncTaskTable>? orderByList,
    _is.Transaction? transaction,
    SiteSyncTaskInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SiteSyncTask>(
      where: where?.call(SiteSyncTask.t),
      orderBy: orderBy?.call(SiteSyncTask.t),
      orderByList: orderByList?.call(SiteSyncTask.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SiteSyncTask] by its [id] or null if no such row exists.
  Future<SiteSyncTask?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SiteSyncTaskInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SiteSyncTask>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SiteSyncTask]s in the list and returns the inserted rows.
  ///
  /// The returned [SiteSyncTask]s will have their `id` fields set.
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
  Future<List<SiteSyncTask>> insert(
    _is.DatabaseSession session,
    List<SiteSyncTask> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SiteSyncTask>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SiteSyncTask] and returns the inserted row.
  ///
  /// The returned [SiteSyncTask] will have its `id` field set.
  Future<SiteSyncTask> insertRow(
    _is.DatabaseSession session,
    SiteSyncTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SiteSyncTask>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SiteSyncTask]s in the list and returns the resulting rows.
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
  /// The returned [SiteSyncTask]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteSyncTask>> upsert(
    _is.DatabaseSession session,
    List<SiteSyncTask> rows, {
    required _is.ColumnSelections<SiteSyncTaskTable> conflictColumns,
    _is.ColumnSelections<SiteSyncTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SiteSyncTask>(
      rows,
      conflictColumns: conflictColumns(SiteSyncTask.t),
      updateColumns: updateColumns?.call(SiteSyncTask.t),
      updateWhere: updateWhere?.call(SiteSyncTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SiteSyncTask] and returns the resulting row.
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
  /// The returned [SiteSyncTask] will have its `id` field set.
  Future<SiteSyncTask?> upsertRow(
    _is.DatabaseSession session,
    SiteSyncTask row, {
    required _is.ColumnSelections<SiteSyncTaskTable> conflictColumns,
    _is.ColumnSelections<SiteSyncTaskTable>? updateColumns,
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SiteSyncTask>(
      row,
      conflictColumns: conflictColumns(SiteSyncTask.t),
      updateColumns: updateColumns?.call(SiteSyncTask.t),
      updateWhere: updateWhere?.call(SiteSyncTask.t),
      transaction: transaction,
    );
  }

  /// Updates all [SiteSyncTask]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteSyncTask>> update(
    _is.DatabaseSession session,
    List<SiteSyncTask> rows, {
    _is.ColumnSelections<SiteSyncTaskTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SiteSyncTask>(
      rows,
      columns: columns?.call(SiteSyncTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SiteSyncTask]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SiteSyncTask> updateRow(
    _is.DatabaseSession session,
    SiteSyncTask row, {
    _is.ColumnSelections<SiteSyncTaskTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SiteSyncTask>(
      row,
      columns: columns?.call(SiteSyncTask.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SiteSyncTask] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SiteSyncTask?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SiteSyncTaskUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SiteSyncTask>(
      id,
      columnValues: columnValues(SiteSyncTask.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SiteSyncTask]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SiteSyncTask>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SiteSyncTaskUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SiteSyncTaskTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SiteSyncTaskTable>? orderBy,
    _is.OrderByListBuilder<SiteSyncTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SiteSyncTask>(
      columnValues: columnValues(SiteSyncTask.t.updateTable),
      where: where(SiteSyncTask.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SiteSyncTask.t),
      orderByList: orderByList?.call(SiteSyncTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SiteSyncTask]s in the list and returns the deleted rows.
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
  Future<List<SiteSyncTask>> delete(
    _is.DatabaseSession session,
    List<SiteSyncTask> rows, {
    _is.OrderByBuilder<SiteSyncTaskTable>? orderBy,
    _is.OrderByListBuilder<SiteSyncTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SiteSyncTask>(
      rows,
      orderBy: orderBy?.call(SiteSyncTask.t),
      orderByList: orderByList?.call(SiteSyncTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SiteSyncTask].
  Future<SiteSyncTask> deleteRow(
    _is.DatabaseSession session,
    SiteSyncTask row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SiteSyncTask>(
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
  Future<List<SiteSyncTask>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteSyncTaskTable> where,
    _is.OrderByBuilder<SiteSyncTaskTable>? orderBy,
    _is.OrderByListBuilder<SiteSyncTaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SiteSyncTask>(
      where: where(SiteSyncTask.t),
      orderBy: orderBy?.call(SiteSyncTask.t),
      orderByList: orderByList?.call(SiteSyncTask.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SiteSyncTaskTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SiteSyncTask>(
      where: where?.call(SiteSyncTask.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SiteSyncTask] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SiteSyncTaskTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SiteSyncTask>(
      where: where(SiteSyncTask.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SiteSyncTaskAttachRowRepository {
  const SiteSyncTaskAttachRowRepository._();

  /// Creates a relation between the given [SiteSyncTask] and [Site]
  /// by setting the [SiteSyncTask]'s foreign key `siteId` to refer to the [Site].
  Future<void> site(
    _is.DatabaseSession session,
    SiteSyncTask siteSyncTask,
    _ie3onmsc.Site site, {
    _is.Transaction? transaction,
  }) async {
    if (siteSyncTask.id == null) {
      throw ArgumentError.notNull('siteSyncTask.id');
    }
    if (site.id == null) {
      throw ArgumentError.notNull('site.id');
    }

    var $siteSyncTask = siteSyncTask.copyWith(siteId: site.id);
    await session.db.updateRow<SiteSyncTask>(
      $siteSyncTask,
      columns: [SiteSyncTask.t.siteId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [SiteSyncTask] and [MemberProfile]
  /// by setting the [SiteSyncTask]'s foreign key `profileId` to refer to the [MemberProfile].
  Future<void> profile(
    _is.DatabaseSession session,
    SiteSyncTask siteSyncTask,
    _ieelrt66.MemberProfile profile, {
    _is.Transaction? transaction,
  }) async {
    if (siteSyncTask.id == null) {
      throw ArgumentError.notNull('siteSyncTask.id');
    }
    if (profile.id == null) {
      throw ArgumentError.notNull('profile.id');
    }

    var $siteSyncTask = siteSyncTask.copyWith(profileId: profile.id);
    await session.db.updateRow<SiteSyncTask>(
      $siteSyncTask,
      columns: [SiteSyncTask.t.profileId],
      transaction: transaction,
    );
  }
}
