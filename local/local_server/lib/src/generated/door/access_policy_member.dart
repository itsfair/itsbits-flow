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
import '../door/access_policy.dart' as _iesob2yd;
import '../site/member_profile.dart' as _iwun33if;

/// Assignment of one member to one access policy — with the validity
/// period PER USER (the policy itself carries no time period). Several
/// assignments (= several policies) OR-combine.
abstract class AccessPolicyMember
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AccessPolicyMember._({
    this.id,
    required this.policyId,
    this.policy,
    required this.memberProfileId,
    this.memberProfile,
    required this.globalAuthUserId,
    DateTime? validFrom,
    this.validUntil,
  }) : validFrom = validFrom ?? DateTime.now();

  factory AccessPolicyMember({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _is.UuidValue globalAuthUserId,
    DateTime? validFrom,
    DateTime? validUntil,
  }) = _AccessPolicyMemberImpl;

  factory AccessPolicyMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessPolicyMember(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _ilsi8fal.Protocol().deserialize<_iesob2yd.AccessPolicy>(
              jsonSerialization['policy'],
            ),
      memberProfileId: jsonSerialization['memberProfileId'] as int,
      memberProfile: jsonSerialization['memberProfile'] == null
          ? null
          : _ilsi8fal.Protocol().deserialize<_iwun33if.MemberProfile>(
              jsonSerialization['memberProfile'],
            ),
      globalAuthUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['globalAuthUserId'],
      ),
      validFrom: jsonSerialization['validFrom'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['validFrom']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
    );
  }

  static final t = AccessPolicyMemberTable();

  static const db = AccessPolicyMemberRepository._();

  @override
  int? id;

  int policyId;

  /// The policy being assigned.
  _iesob2yd.AccessPolicy? policy;

  int memberProfileId;

  /// The assigned person (mirror row).
  _iwun33if.MemberProfile? memberProfile;

  /// Denormalized exchange id — the verifier looks up by this (no join),
  /// same pattern as member_membership.
  _is.UuidValue globalAuthUserId;

  /// Assignment validity start (local time; default now).
  DateTime validFrom;

  /// Assignment validity end (null = unlimited).
  DateTime? validUntil;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccessPolicyMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccessPolicyMember copyWith({
    int? id,
    int? policyId,
    _iesob2yd.AccessPolicy? policy,
    int? memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    _is.UuidValue? globalAuthUserId,
    DateTime? validFrom,
    DateTime? validUntil,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessPolicyMember',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      'memberProfileId': memberProfileId,
      if (memberProfile != null) 'memberProfile': memberProfile?.toJson(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccessPolicyMember',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      'memberProfileId': memberProfileId,
      if (memberProfile != null)
        'memberProfile': memberProfile?.toJsonForProtocol(),
      'globalAuthUserId': globalAuthUserId.toJson(),
      'validFrom': validFrom.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
    };
  }

  static AccessPolicyMemberInclude include({
    _iesob2yd.AccessPolicyInclude? policy,
    _iwun33if.MemberProfileInclude? memberProfile,
  }) {
    return AccessPolicyMemberInclude._(
      policy: policy,
      memberProfile: memberProfile,
    );
  }

  static AccessPolicyMemberIncludeList includeList({
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyMemberTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyMemberTable>? orderByList,
    AccessPolicyMemberInclude? include,
  }) {
    return AccessPolicyMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessPolicyMember.t),
      orderByList: orderByList?.call(AccessPolicyMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessPolicyMemberImpl extends AccessPolicyMember {
  _AccessPolicyMemberImpl({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    required int memberProfileId,
    _iwun33if.MemberProfile? memberProfile,
    required _is.UuidValue globalAuthUserId,
    DateTime? validFrom,
    DateTime? validUntil,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         memberProfileId: memberProfileId,
         memberProfile: memberProfile,
         globalAuthUserId: globalAuthUserId,
         validFrom: validFrom,
         validUntil: validUntil,
       );

  /// Returns a shallow copy of this [AccessPolicyMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccessPolicyMember copyWith({
    Object? id = _Undefined,
    int? policyId,
    Object? policy = _Undefined,
    int? memberProfileId,
    Object? memberProfile = _Undefined,
    _is.UuidValue? globalAuthUserId,
    DateTime? validFrom,
    Object? validUntil = _Undefined,
  }) {
    return AccessPolicyMember(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _iesob2yd.AccessPolicy?
          ? policy
          : this.policy?.copyWith(),
      memberProfileId: memberProfileId ?? this.memberProfileId,
      memberProfile: memberProfile is _iwun33if.MemberProfile?
          ? memberProfile
          : this.memberProfile?.copyWith(),
      globalAuthUserId: globalAuthUserId ?? this.globalAuthUserId,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
    );
  }
}

class AccessPolicyMemberUpdateTable
    extends _is.UpdateTable<AccessPolicyMemberTable> {
  AccessPolicyMemberUpdateTable(super.table);

  _is.ColumnValue<int, int> policyId(int value) => _is.ColumnValue(
    table.policyId,
    value,
  );

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

  _is.ColumnValue<DateTime, DateTime> validFrom(DateTime value) =>
      _is.ColumnValue(
        table.validFrom,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> validUntil(DateTime? value) =>
      _is.ColumnValue(
        table.validUntil,
        value,
      );
}

class AccessPolicyMemberTable extends _is.Table<int?> {
  AccessPolicyMemberTable({super.tableRelation})
    : super(tableName: 'access_policy_members') {
    updateTable = AccessPolicyMemberUpdateTable(this);
    policyId = _is.ColumnInt(
      'policyId',
      this,
    );
    memberProfileId = _is.ColumnInt(
      'memberProfileId',
      this,
    );
    globalAuthUserId = _is.ColumnUuid(
      'globalAuthUserId',
      this,
    );
    validFrom = _is.ColumnDateTime(
      'validFrom',
      this,
    );
    validUntil = _is.ColumnDateTime(
      'validUntil',
      this,
    );
  }

  late final AccessPolicyMemberUpdateTable updateTable;

  late final _is.ColumnInt policyId;

  /// The policy being assigned.
  _iesob2yd.AccessPolicyTable? _policy;

  late final _is.ColumnInt memberProfileId;

  /// The assigned person (mirror row).
  _iwun33if.MemberProfileTable? _memberProfile;

  /// Denormalized exchange id — the verifier looks up by this (no join),
  /// same pattern as member_membership.
  late final _is.ColumnUuid globalAuthUserId;

  /// Assignment validity start (local time; default now).
  late final _is.ColumnDateTime validFrom;

  /// Assignment validity end (null = unlimited).
  late final _is.ColumnDateTime validUntil;

  _iesob2yd.AccessPolicyTable get policy {
    if (_policy != null) return _policy!;
    _policy = _is.createRelationTable(
      relationFieldName: 'policy',
      field: AccessPolicyMember.t.policyId,
      foreignField: _iesob2yd.AccessPolicy.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iesob2yd.AccessPolicyTable(tableRelation: foreignTableRelation),
    );
    return _policy!;
  }

  _iwun33if.MemberProfileTable get memberProfile {
    if (_memberProfile != null) return _memberProfile!;
    _memberProfile = _is.createRelationTable(
      relationFieldName: 'memberProfile',
      field: AccessPolicyMember.t.memberProfileId,
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
    policyId,
    memberProfileId,
    globalAuthUserId,
    validFrom,
    validUntil,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'policy') {
      return policy;
    }
    if (relationField == 'memberProfile') {
      return memberProfile;
    }
    return null;
  }
}

class AccessPolicyMemberInclude extends _is.IncludeObject {
  AccessPolicyMemberInclude._({
    _iesob2yd.AccessPolicyInclude? policy,
    _iwun33if.MemberProfileInclude? memberProfile,
  }) {
    _policy = policy;
    _memberProfile = memberProfile;
  }

  _iesob2yd.AccessPolicyInclude? _policy;

  _iwun33if.MemberProfileInclude? _memberProfile;

  @override
  Map<String, _is.Include?> get includes => {
    'policy': _policy,
    'memberProfile': _memberProfile,
  };

  @override
  _is.Table<int?> get table => AccessPolicyMember.t;
}

class AccessPolicyMemberIncludeList extends _is.IncludeList {
  AccessPolicyMemberIncludeList._({
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccessPolicyMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AccessPolicyMember.t;
}

class AccessPolicyMemberRepository {
  const AccessPolicyMemberRepository._();

  final attachRow = const AccessPolicyMemberAttachRowRepository._();

  /// Returns a list of [AccessPolicyMember]s matching the given query parameters.
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
  Future<List<AccessPolicyMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyMemberTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyMemberTable>? orderByList,
    _is.Transaction? transaction,
    AccessPolicyMemberInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccessPolicyMember>(
      where: where?.call(AccessPolicyMember.t),
      orderBy: orderBy?.call(AccessPolicyMember.t),
      orderByList: orderByList?.call(AccessPolicyMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccessPolicyMember] matching the given query parameters.
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
  Future<AccessPolicyMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<AccessPolicyMemberTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyMemberTable>? orderByList,
    _is.Transaction? transaction,
    AccessPolicyMemberInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccessPolicyMember>(
      where: where?.call(AccessPolicyMember.t),
      orderBy: orderBy?.call(AccessPolicyMember.t),
      orderByList: orderByList?.call(AccessPolicyMember.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccessPolicyMember] by its [id] or null if no such row exists.
  Future<AccessPolicyMember?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    AccessPolicyMemberInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccessPolicyMember>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccessPolicyMember]s in the list and returns the inserted rows.
  ///
  /// The returned [AccessPolicyMember]s will have their `id` fields set.
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
  Future<List<AccessPolicyMember>> insert(
    _is.DatabaseSession session,
    List<AccessPolicyMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccessPolicyMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccessPolicyMember] and returns the inserted row.
  ///
  /// The returned [AccessPolicyMember] will have its `id` field set.
  Future<AccessPolicyMember> insertRow(
    _is.DatabaseSession session,
    AccessPolicyMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccessPolicyMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccessPolicyMember]s in the list and returns the resulting rows.
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
  /// The returned [AccessPolicyMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicyMember>> upsert(
    _is.DatabaseSession session,
    List<AccessPolicyMember> rows, {
    required _is.ColumnSelections<AccessPolicyMemberTable> conflictColumns,
    _is.ColumnSelections<AccessPolicyMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccessPolicyMember>(
      rows,
      conflictColumns: conflictColumns(AccessPolicyMember.t),
      updateColumns: updateColumns?.call(AccessPolicyMember.t),
      updateWhere: updateWhere?.call(AccessPolicyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccessPolicyMember] and returns the resulting row.
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
  /// The returned [AccessPolicyMember] will have its `id` field set.
  Future<AccessPolicyMember?> upsertRow(
    _is.DatabaseSession session,
    AccessPolicyMember row, {
    required _is.ColumnSelections<AccessPolicyMemberTable> conflictColumns,
    _is.ColumnSelections<AccessPolicyMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccessPolicyMember>(
      row,
      conflictColumns: conflictColumns(AccessPolicyMember.t),
      updateColumns: updateColumns?.call(AccessPolicyMember.t),
      updateWhere: updateWhere?.call(AccessPolicyMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccessPolicyMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicyMember>> update(
    _is.DatabaseSession session,
    List<AccessPolicyMember> rows, {
    _is.ColumnSelections<AccessPolicyMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccessPolicyMember>(
      rows,
      columns: columns?.call(AccessPolicyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccessPolicyMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccessPolicyMember> updateRow(
    _is.DatabaseSession session,
    AccessPolicyMember row, {
    _is.ColumnSelections<AccessPolicyMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccessPolicyMember>(
      row,
      columns: columns?.call(AccessPolicyMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccessPolicyMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccessPolicyMember?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AccessPolicyMemberUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccessPolicyMember>(
      id,
      columnValues: columnValues(AccessPolicyMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccessPolicyMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicyMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccessPolicyMemberUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AccessPolicyMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyMemberTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccessPolicyMember>(
      columnValues: columnValues(AccessPolicyMember.t.updateTable),
      where: where(AccessPolicyMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessPolicyMember.t),
      orderByList: orderByList?.call(AccessPolicyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccessPolicyMember]s in the list and returns the deleted rows.
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
  Future<List<AccessPolicyMember>> delete(
    _is.DatabaseSession session,
    List<AccessPolicyMember> rows, {
    _is.OrderByBuilder<AccessPolicyMemberTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccessPolicyMember>(
      rows,
      orderBy: orderBy?.call(AccessPolicyMember.t),
      orderByList: orderByList?.call(AccessPolicyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccessPolicyMember].
  Future<AccessPolicyMember> deleteRow(
    _is.DatabaseSession session,
    AccessPolicyMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccessPolicyMember>(
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
  Future<List<AccessPolicyMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessPolicyMemberTable> where,
    _is.OrderByBuilder<AccessPolicyMemberTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccessPolicyMember>(
      where: where(AccessPolicyMember.t),
      orderBy: orderBy?.call(AccessPolicyMember.t),
      orderByList: orderByList?.call(AccessPolicyMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccessPolicyMember>(
      where: where?.call(AccessPolicyMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccessPolicyMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessPolicyMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccessPolicyMember>(
      where: where(AccessPolicyMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AccessPolicyMemberAttachRowRepository {
  const AccessPolicyMemberAttachRowRepository._();

  /// Creates a relation between the given [AccessPolicyMember] and [AccessPolicy]
  /// by setting the [AccessPolicyMember]'s foreign key `policyId` to refer to the [AccessPolicy].
  Future<void> policy(
    _is.DatabaseSession session,
    AccessPolicyMember accessPolicyMember,
    _iesob2yd.AccessPolicy policy, {
    _is.Transaction? transaction,
  }) async {
    if (accessPolicyMember.id == null) {
      throw ArgumentError.notNull('accessPolicyMember.id');
    }
    if (policy.id == null) {
      throw ArgumentError.notNull('policy.id');
    }

    var $accessPolicyMember = accessPolicyMember.copyWith(policyId: policy.id);
    await session.db.updateRow<AccessPolicyMember>(
      $accessPolicyMember,
      columns: [AccessPolicyMember.t.policyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccessPolicyMember] and [MemberProfile]
  /// by setting the [AccessPolicyMember]'s foreign key `memberProfileId` to refer to the [MemberProfile].
  Future<void> memberProfile(
    _is.DatabaseSession session,
    AccessPolicyMember accessPolicyMember,
    _iwun33if.MemberProfile memberProfile, {
    _is.Transaction? transaction,
  }) async {
    if (accessPolicyMember.id == null) {
      throw ArgumentError.notNull('accessPolicyMember.id');
    }
    if (memberProfile.id == null) {
      throw ArgumentError.notNull('memberProfile.id');
    }

    var $accessPolicyMember = accessPolicyMember.copyWith(
      memberProfileId: memberProfile.id,
    );
    await session.db.updateRow<AccessPolicyMember>(
      $accessPolicyMember,
      columns: [AccessPolicyMember.t.memberProfileId],
      transaction: transaction,
    );
  }
}
