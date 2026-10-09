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
import 'package:local_server/src/generated/protocol.dart' as _ilsi8fal;
import 'package:serverpod/serverpod.dart' as _is;
import '../site/member_profile.dart' as _iwun33if;
import '../site/member_role.dart' as _iampahbt;

/// Local mirror of a global site membership (role/active bookkeeping —
/// root-AGENTS open item). Deactivation sets `active=false` + `endedAt`;
/// the person rows are KEPT so the site can still view its members.
/// Staff/admin roles later switch the local login behavior (employees
/// flow) — that mapping is implemented with the employees feature.
abstract class MemberMembership
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MemberMembership._({
    this.id,
    required this.memberProfileId,
    this.memberProfile,
    required this.globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    this.endedAt,
    DateTime? createdAt,
  }) : role = role ?? _iampahbt.MemberRole.member,
       active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory MemberMembership({
    int? id,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _is.UuidValue globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  }) = _MemberMembershipImpl;

  factory MemberMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberMembership(
      id: jsonSerialization['id'] as int?,
      memberProfileId: jsonSerialization['memberProfileId'] as int,
      memberProfile: jsonSerialization['memberProfile'] == null
          ? null
          : _ilsi8fal.Protocol().deserialize<_iwun33if.MemberProfile>(
              jsonSerialization['memberProfile'],
            ),
      globalAuthUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      role: jsonSerialization['role'] == null
          ? null
          : _iampahbt.MemberRole.fromJson(
              (jsonSerialization['role'] as String),
            ),
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = MemberMembershipTable();

  static const db = MemberMembershipRepository._();

  @override
  int? id;

  int memberProfileId;

  /// The local member_profile copy this membership belongs to.
  _iwun33if.MemberProfile? memberProfile;

  /// Denormalized exchange id (same as the profile's globalAuthUserId).
  _is.UuidValue globalAuthUserId;

  /// Mirror of the global SiteRole.
  _iampahbt.MemberRole role;

  /// Lifecycle mirror (false = deactivated; data kept).
  bool active;

  /// Deactivation marker (null while active).
  DateTime? endedAt;

  /// When the membership known to this instance was created.
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MemberMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MemberMembership copyWith({
    int? id,
    int? memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    _is.UuidValue? globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberMembership',
      if (id != null) 'id': id,
      'memberProfileId': memberProfileId,
      if (memberProfile != null) 'memberProfile': memberProfile?.toJson(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'role': role.toJson(),
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberMembership',
      if (id != null) 'id': id,
      'memberProfileId': memberProfileId,
      if (memberProfile != null)
        'memberProfile': memberProfile?.toJsonForProtocol(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'role': role.toJson(),
      'active': active,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static MemberMembershipInclude include({
    _iwun33if.MemberProfileInclude? memberProfile,
  }) {
    return MemberMembershipInclude._(memberProfile: memberProfile);
  }

  static MemberMembershipIncludeList includeList({
    _is.WhereExpressionBuilder<MemberMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MemberMembershipTable>? orderBy,
    _is.OrderByListBuilder<MemberMembershipTable>? orderByList,
    MemberMembershipInclude? include,
  }) {
    return MemberMembershipIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MemberMembership.t),
      orderByList: orderByList?.call(MemberMembership.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberMembershipImpl extends MemberMembership {
  _MemberMembershipImpl({
    int? id,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _is.UuidValue globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    DateTime? endedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         memberProfileId: memberProfileId,
         memberProfile: memberProfile,
         globalAuthUserId: globalAuthUserId,
         role: role,
         active: active,
         endedAt: endedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MemberMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MemberMembership copyWith({
    Object? id = _Undefined,
    int? memberProfileId,
    Object? memberProfile = _Undefined,
    _is.UuidValue? globalAuthUserId,
    _iampahbt.MemberRole? role,
    bool? active,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return MemberMembership(
      id: id is int? ? id : this.id,
      memberProfileId: memberProfileId ?? this.memberProfileId,
      memberProfile: memberProfile is _iwun33if.MemberProfile?
          ? memberProfile
          : this.memberProfile?.copyWith(),
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      role: role ?? this.role,
      active: active ?? this.active,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class MemberMembershipUpdateTable
    extends _is.UpdateTable<MemberMembershipTable> {
  MemberMembershipUpdateTable(super.table);

  _is.ColumnValue<int, int> memberProfileId(int value) => _is.ColumnValue(
    table.memberProfileId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> globalAuthUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.globalAuthUserId,
    value,
  );

  _is.ColumnValue<_iampahbt.MemberRole, _iampahbt.MemberRole> role(
    _iampahbt.MemberRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> endedAt(DateTime? value) =>
      _is.ColumnValue(
        table.endedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class MemberMembershipTable extends _is.Table<int?> {
  MemberMembershipTable({super.tableRelation})
    : super(tableName: 'member_memberships') {
    updateTable = MemberMembershipUpdateTable(this);
    memberProfileId = _is.ColumnInt(
      'memberProfileId',
      this,
    );
    globalAuthUserId = _is.ColumnUuid(
      'globalAuthUserId',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
    );
    active = _is.ColumnBool(
      'active',
      this,
    );
    endedAt = _is.ColumnDateTime(
      'endedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final MemberMembershipUpdateTable updateTable;

  late final _is.ColumnInt memberProfileId;

  /// The local member_profile copy this membership belongs to.
  _iwun33if.MemberProfileTable? _memberProfile;

  /// Denormalized exchange id (same as the profile's globalAuthUserId).
  late final _is.ColumnUuid globalAuthUserId;

  /// Mirror of the global SiteRole.
  late final _is.ColumnEnum<_iampahbt.MemberRole> role;

  /// Lifecycle mirror (false = deactivated; data kept).
  late final _is.ColumnBool active;

  /// Deactivation marker (null while active).
  late final _is.ColumnDateTime endedAt;

  /// When the membership known to this instance was created.
  late final _is.ColumnDateTime createdAt;

  _iwun33if.MemberProfileTable get memberProfile {
    if (_memberProfile != null) return _memberProfile!;
    _memberProfile = _is.createRelationTable(
      relationFieldName: 'memberProfile',
      field: MemberMembership.t.memberProfileId,
      foreignField: _iwun33if.MemberProfile.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iwun33if.MemberProfileTable(tableRelation: foreignTableRelation),
    );
    return _memberProfile!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    memberProfileId,
    globalAuthUserId,
    role,
    active,
    endedAt,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'memberProfile') {
      return memberProfile;
    }
    return null;
  }
}

class MemberMembershipInclude extends _is.IncludeObject {
  MemberMembershipInclude._({_iwun33if.MemberProfileInclude? memberProfile}) {
    _memberProfile = memberProfile;
  }

  _iwun33if.MemberProfileInclude? _memberProfile;

  @override
  Map<String, _is.Include?> get includes => {'memberProfile': _memberProfile};

  @override
  _is.Table<int?> get table => MemberMembership.t;
}

class MemberMembershipIncludeList extends _is.IncludeList {
  MemberMembershipIncludeList._({
    _is.WhereExpressionBuilder<MemberMembershipTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MemberMembership.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MemberMembership.t;
}

class MemberMembershipRepository {
  const MemberMembershipRepository._();

  final attachRow = const MemberMembershipAttachRowRepository._();

  /// Returns a list of [MemberMembership]s matching the given query parameters.
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
  Future<List<MemberMembership>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MemberMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MemberMembershipTable>? orderBy,
    _is.OrderByListBuilder<MemberMembershipTable>? orderByList,
    _is.Transaction? transaction,
    MemberMembershipInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MemberMembership>(
      where: where?.call(MemberMembership.t),
      orderBy: orderBy?.call(MemberMembership.t),
      orderByList: orderByList?.call(MemberMembership.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MemberMembership] matching the given query parameters.
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
  Future<MemberMembership?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MemberMembershipTable>? where,
    int? offset,
    _is.OrderByBuilder<MemberMembershipTable>? orderBy,
    _is.OrderByListBuilder<MemberMembershipTable>? orderByList,
    _is.Transaction? transaction,
    MemberMembershipInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MemberMembership>(
      where: where?.call(MemberMembership.t),
      orderBy: orderBy?.call(MemberMembership.t),
      orderByList: orderByList?.call(MemberMembership.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MemberMembership] by its [id] or null if no such row exists.
  Future<MemberMembership?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    MemberMembershipInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MemberMembership>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MemberMembership]s in the list and returns the inserted rows.
  ///
  /// The returned [MemberMembership]s will have their `id` fields set.
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
  Future<List<MemberMembership>> insert(
    _is.DatabaseSession session,
    List<MemberMembership> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MemberMembership>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MemberMembership] and returns the inserted row.
  ///
  /// The returned [MemberMembership] will have its `id` field set.
  Future<MemberMembership> insertRow(
    _is.DatabaseSession session,
    MemberMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MemberMembership>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MemberMembership]s in the list and returns the resulting rows.
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
  /// The returned [MemberMembership]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MemberMembership>> upsert(
    _is.DatabaseSession session,
    List<MemberMembership> rows, {
    required _is.ColumnSelections<MemberMembershipTable> conflictColumns,
    _is.ColumnSelections<MemberMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<MemberMembershipTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MemberMembership>(
      rows,
      conflictColumns: conflictColumns(MemberMembership.t),
      updateColumns: updateColumns?.call(MemberMembership.t),
      updateWhere: updateWhere?.call(MemberMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MemberMembership] and returns the resulting row.
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
  /// The returned [MemberMembership] will have its `id` field set.
  Future<MemberMembership?> upsertRow(
    _is.DatabaseSession session,
    MemberMembership row, {
    required _is.ColumnSelections<MemberMembershipTable> conflictColumns,
    _is.ColumnSelections<MemberMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<MemberMembershipTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MemberMembership>(
      row,
      conflictColumns: conflictColumns(MemberMembership.t),
      updateColumns: updateColumns?.call(MemberMembership.t),
      updateWhere: updateWhere?.call(MemberMembership.t),
      transaction: transaction,
    );
  }

  /// Updates all [MemberMembership]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MemberMembership>> update(
    _is.DatabaseSession session,
    List<MemberMembership> rows, {
    _is.ColumnSelections<MemberMembershipTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MemberMembership>(
      rows,
      columns: columns?.call(MemberMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MemberMembership]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MemberMembership> updateRow(
    _is.DatabaseSession session,
    MemberMembership row, {
    _is.ColumnSelections<MemberMembershipTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MemberMembership>(
      row,
      columns: columns?.call(MemberMembership.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MemberMembership] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MemberMembership?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MemberMembershipUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MemberMembership>(
      id,
      columnValues: columnValues(MemberMembership.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MemberMembership]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MemberMembership>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MemberMembershipUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<MemberMembershipTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MemberMembershipTable>? orderBy,
    _is.OrderByListBuilder<MemberMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MemberMembership>(
      columnValues: columnValues(MemberMembership.t.updateTable),
      where: where(MemberMembership.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MemberMembership.t),
      orderByList: orderByList?.call(MemberMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MemberMembership]s in the list and returns the deleted rows.
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
  Future<List<MemberMembership>> delete(
    _is.DatabaseSession session,
    List<MemberMembership> rows, {
    _is.OrderByBuilder<MemberMembershipTable>? orderBy,
    _is.OrderByListBuilder<MemberMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MemberMembership>(
      rows,
      orderBy: orderBy?.call(MemberMembership.t),
      orderByList: orderByList?.call(MemberMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MemberMembership].
  Future<MemberMembership> deleteRow(
    _is.DatabaseSession session,
    MemberMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MemberMembership>(
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
  Future<List<MemberMembership>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MemberMembershipTable> where,
    _is.OrderByBuilder<MemberMembershipTable>? orderBy,
    _is.OrderByListBuilder<MemberMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MemberMembership>(
      where: where(MemberMembership.t),
      orderBy: orderBy?.call(MemberMembership.t),
      orderByList: orderByList?.call(MemberMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MemberMembershipTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MemberMembership>(
      where: where?.call(MemberMembership.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MemberMembership] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MemberMembershipTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MemberMembership>(
      where: where(MemberMembership.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class MemberMembershipAttachRowRepository {
  const MemberMembershipAttachRowRepository._();

  /// Creates a relation between the given [MemberMembership] and [MemberProfile]
  /// by setting the [MemberMembership]'s foreign key `memberProfileId` to refer to the [MemberProfile].
  Future<void> memberProfile(
    _is.DatabaseSession session,
    MemberMembership memberMembership,
    _iwun33if.MemberProfile memberProfile, {
    _is.Transaction? transaction,
  }) async {
    if (memberMembership.id == null) {
      throw ArgumentError.notNull('memberMembership.id');
    }
    if (memberProfile.id == null) {
      throw ArgumentError.notNull('memberProfile.id');
    }

    var $memberMembership = memberMembership.copyWith(
      memberProfileId: memberProfile.id,
    );
    await session.db.updateRow<MemberMembership>(
      $memberMembership,
      columns: [MemberMembership.t.memberProfileId],
      transaction: transaction,
    );
  }
}
