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
import '../door/door_device.dart' as _i3q1tj4m;

/// One rule of an access policy: which door may be opened on which
/// weekday in which minute window (SERVER-LOCAL time = site time).
/// endMinute is exclusive; 1440 encodes "midnight end" (24:00).
/// Overnight windows are expressed as TWO rules (Mo 22:00-23:59 + Di
/// 00:00-04:00) — no wrap semantics.
abstract class AccessPolicyRule
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AccessPolicyRule._({
    this.id,
    required this.policyId,
    this.policy,
    this.deviceId,
    this.device,
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
  });

  factory AccessPolicyRule({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    int? deviceId,
    _i3q1tj4m.DoorDevice? device,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) = _AccessPolicyRuleImpl;

  factory AccessPolicyRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessPolicyRule(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _ilsi8fal.Protocol().deserialize<_iesob2yd.AccessPolicy>(
              jsonSerialization['policy'],
            ),
      deviceId: jsonSerialization['deviceId'] as int?,
      device: jsonSerialization['device'] == null
          ? null
          : _ilsi8fal.Protocol().deserialize<_i3q1tj4m.DoorDevice>(
              jsonSerialization['device'],
            ),
      weekday: jsonSerialization['weekday'] as int,
      startMinute: jsonSerialization['startMinute'] as int,
      endMinute: jsonSerialization['endMinute'] as int,
    );
  }

  static final t = AccessPolicyRuleTable();

  static const db = AccessPolicyRuleRepository._();

  @override
  int? id;

  int policyId;

  /// The policy this rule belongs to.
  _iesob2yd.AccessPolicy? policy;

  int? deviceId;

  /// The door device this rule grants (null = ALL registered doors).
  _i3q1tj4m.DoorDevice? device;

  /// 0 = Monday … 6 = Sunday (server-local weekday).
  int weekday;

  /// Window start, minutes since local midnight (0-1439).
  int startMinute;

  /// Window end, EXCLUSIVE minutes (1-1440; 1440 = midnight end).
  int endMinute;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccessPolicyRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AccessPolicyRule copyWith({
    int? id,
    int? policyId,
    _iesob2yd.AccessPolicy? policy,
    int? deviceId,
    _i3q1tj4m.DoorDevice? device,
    int? weekday,
    int? startMinute,
    int? endMinute,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccessPolicyRule',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      'weekday': weekday,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccessPolicyRule',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      'weekday': weekday,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }

  static AccessPolicyRuleInclude include({
    _iesob2yd.AccessPolicyInclude? policy,
    _i3q1tj4m.DoorDeviceInclude? device,
  }) {
    return AccessPolicyRuleInclude._(
      policy: policy,
      device: device,
    );
  }

  static AccessPolicyRuleIncludeList includeList({
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyRuleTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyRuleTable>? orderByList,
    AccessPolicyRuleInclude? include,
  }) {
    return AccessPolicyRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessPolicyRule.t),
      orderByList: orderByList?.call(AccessPolicyRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessPolicyRuleImpl extends AccessPolicyRule {
  _AccessPolicyRuleImpl({
    int? id,
    required int policyId,
    _iesob2yd.AccessPolicy? policy,
    int? deviceId,
    _i3q1tj4m.DoorDevice? device,
    required int weekday,
    required int startMinute,
    required int endMinute,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         deviceId: deviceId,
         device: device,
         weekday: weekday,
         startMinute: startMinute,
         endMinute: endMinute,
       );

  /// Returns a shallow copy of this [AccessPolicyRule]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AccessPolicyRule copyWith({
    Object? id = _Undefined,
    int? policyId,
    Object? policy = _Undefined,
    Object? deviceId = _Undefined,
    Object? device = _Undefined,
    int? weekday,
    int? startMinute,
    int? endMinute,
  }) {
    return AccessPolicyRule(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _iesob2yd.AccessPolicy?
          ? policy
          : this.policy?.copyWith(),
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      device: device is _i3q1tj4m.DoorDevice?
          ? device
          : this.device?.copyWith(),
      weekday: weekday ?? this.weekday,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
    );
  }
}

class AccessPolicyRuleUpdateTable
    extends _is.UpdateTable<AccessPolicyRuleTable> {
  AccessPolicyRuleUpdateTable(super.table);

  _is.ColumnValue<int, int> policyId(int value) => _is.ColumnValue(
    table.policyId,
    value,
  );

  _is.ColumnValue<int, int> deviceId(int? value) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<int, int> weekday(int value) => _is.ColumnValue(
    table.weekday,
    value,
  );

  _is.ColumnValue<int, int> startMinute(int value) => _is.ColumnValue(
    table.startMinute,
    value,
  );

  _is.ColumnValue<int, int> endMinute(int value) => _is.ColumnValue(
    table.endMinute,
    value,
  );
}

class AccessPolicyRuleTable extends _is.Table<int?> {
  AccessPolicyRuleTable({super.tableRelation})
    : super(tableName: 'access_policy_rules') {
    updateTable = AccessPolicyRuleUpdateTable(this);
    policyId = _is.ColumnInt(
      'policyId',
      this,
    );
    deviceId = _is.ColumnInt(
      'deviceId',
      this,
    );
    weekday = _is.ColumnInt(
      'weekday',
      this,
    );
    startMinute = _is.ColumnInt(
      'startMinute',
      this,
    );
    endMinute = _is.ColumnInt(
      'endMinute',
      this,
    );
  }

  late final AccessPolicyRuleUpdateTable updateTable;

  late final _is.ColumnInt policyId;

  /// The policy this rule belongs to.
  _iesob2yd.AccessPolicyTable? _policy;

  late final _is.ColumnInt deviceId;

  /// The door device this rule grants (null = ALL registered doors).
  _i3q1tj4m.DoorDeviceTable? _device;

  /// 0 = Monday … 6 = Sunday (server-local weekday).
  late final _is.ColumnInt weekday;

  /// Window start, minutes since local midnight (0-1439).
  late final _is.ColumnInt startMinute;

  /// Window end, EXCLUSIVE minutes (1-1440; 1440 = midnight end).
  late final _is.ColumnInt endMinute;

  _iesob2yd.AccessPolicyTable get policy {
    if (_policy != null) return _policy!;
    _policy = _is.createRelationTable(
      relationFieldName: 'policy',
      field: AccessPolicyRule.t.policyId,
      foreignField: _iesob2yd.AccessPolicy.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iesob2yd.AccessPolicyTable(tableRelation: foreignTableRelation),
    );
    return _policy!;
  }

  _i3q1tj4m.DoorDeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: AccessPolicyRule.t.deviceId,
      foreignField: _i3q1tj4m.DoorDevice.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3q1tj4m.DoorDeviceTable(tableRelation: foreignTableRelation),
    );
    return _device!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    policyId,
    deviceId,
    weekday,
    startMinute,
    endMinute,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'policy') {
      return policy;
    }
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class AccessPolicyRuleInclude extends _is.IncludeObject {
  AccessPolicyRuleInclude._({
    _iesob2yd.AccessPolicyInclude? policy,
    _i3q1tj4m.DoorDeviceInclude? device,
  }) {
    _policy = policy;
    _device = device;
  }

  _iesob2yd.AccessPolicyInclude? _policy;

  _i3q1tj4m.DoorDeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {
    'policy': _policy,
    'device': _device,
  };

  @override
  _is.Table<int?> get table => AccessPolicyRule.t;
}

class AccessPolicyRuleIncludeList extends _is.IncludeList {
  AccessPolicyRuleIncludeList._({
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccessPolicyRule.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AccessPolicyRule.t;
}

class AccessPolicyRuleRepository {
  const AccessPolicyRuleRepository._();

  final attachRow = const AccessPolicyRuleAttachRowRepository._();

  final detachRow = const AccessPolicyRuleDetachRowRepository._();

  /// Returns a list of [AccessPolicyRule]s matching the given query parameters.
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
  Future<List<AccessPolicyRule>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyRuleTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyRuleTable>? orderByList,
    _is.Transaction? transaction,
    AccessPolicyRuleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AccessPolicyRule>(
      where: where?.call(AccessPolicyRule.t),
      orderBy: orderBy?.call(AccessPolicyRule.t),
      orderByList: orderByList?.call(AccessPolicyRule.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AccessPolicyRule] matching the given query parameters.
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
  Future<AccessPolicyRule?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? where,
    int? offset,
    _is.OrderByBuilder<AccessPolicyRuleTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyRuleTable>? orderByList,
    _is.Transaction? transaction,
    AccessPolicyRuleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AccessPolicyRule>(
      where: where?.call(AccessPolicyRule.t),
      orderBy: orderBy?.call(AccessPolicyRule.t),
      orderByList: orderByList?.call(AccessPolicyRule.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AccessPolicyRule] by its [id] or null if no such row exists.
  Future<AccessPolicyRule?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    AccessPolicyRuleInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AccessPolicyRule>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AccessPolicyRule]s in the list and returns the inserted rows.
  ///
  /// The returned [AccessPolicyRule]s will have their `id` fields set.
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
  Future<List<AccessPolicyRule>> insert(
    _is.DatabaseSession session,
    List<AccessPolicyRule> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AccessPolicyRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AccessPolicyRule] and returns the inserted row.
  ///
  /// The returned [AccessPolicyRule] will have its `id` field set.
  Future<AccessPolicyRule> insertRow(
    _is.DatabaseSession session,
    AccessPolicyRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccessPolicyRule>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AccessPolicyRule]s in the list and returns the resulting rows.
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
  /// The returned [AccessPolicyRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicyRule>> upsert(
    _is.DatabaseSession session,
    List<AccessPolicyRule> rows, {
    required _is.ColumnSelections<AccessPolicyRuleTable> conflictColumns,
    _is.ColumnSelections<AccessPolicyRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AccessPolicyRule>(
      rows,
      conflictColumns: conflictColumns(AccessPolicyRule.t),
      updateColumns: updateColumns?.call(AccessPolicyRule.t),
      updateWhere: updateWhere?.call(AccessPolicyRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AccessPolicyRule] and returns the resulting row.
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
  /// The returned [AccessPolicyRule] will have its `id` field set.
  Future<AccessPolicyRule?> upsertRow(
    _is.DatabaseSession session,
    AccessPolicyRule row, {
    required _is.ColumnSelections<AccessPolicyRuleTable> conflictColumns,
    _is.ColumnSelections<AccessPolicyRuleTable>? updateColumns,
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AccessPolicyRule>(
      row,
      conflictColumns: conflictColumns(AccessPolicyRule.t),
      updateColumns: updateColumns?.call(AccessPolicyRule.t),
      updateWhere: updateWhere?.call(AccessPolicyRule.t),
      transaction: transaction,
    );
  }

  /// Updates all [AccessPolicyRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicyRule>> update(
    _is.DatabaseSession session,
    List<AccessPolicyRule> rows, {
    _is.ColumnSelections<AccessPolicyRuleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AccessPolicyRule>(
      rows,
      columns: columns?.call(AccessPolicyRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AccessPolicyRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccessPolicyRule> updateRow(
    _is.DatabaseSession session,
    AccessPolicyRule row, {
    _is.ColumnSelections<AccessPolicyRuleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccessPolicyRule>(
      row,
      columns: columns?.call(AccessPolicyRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccessPolicyRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccessPolicyRule?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AccessPolicyRuleUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AccessPolicyRule>(
      id,
      columnValues: columnValues(AccessPolicyRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccessPolicyRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AccessPolicyRule>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AccessPolicyRuleUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<AccessPolicyRuleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AccessPolicyRuleTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AccessPolicyRule>(
      columnValues: columnValues(AccessPolicyRule.t.updateTable),
      where: where(AccessPolicyRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessPolicyRule.t),
      orderByList: orderByList?.call(AccessPolicyRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AccessPolicyRule]s in the list and returns the deleted rows.
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
  Future<List<AccessPolicyRule>> delete(
    _is.DatabaseSession session,
    List<AccessPolicyRule> rows, {
    _is.OrderByBuilder<AccessPolicyRuleTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AccessPolicyRule>(
      rows,
      orderBy: orderBy?.call(AccessPolicyRule.t),
      orderByList: orderByList?.call(AccessPolicyRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AccessPolicyRule].
  Future<AccessPolicyRule> deleteRow(
    _is.DatabaseSession session,
    AccessPolicyRule row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccessPolicyRule>(
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
  Future<List<AccessPolicyRule>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessPolicyRuleTable> where,
    _is.OrderByBuilder<AccessPolicyRuleTable>? orderBy,
    _is.OrderByListBuilder<AccessPolicyRuleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AccessPolicyRule>(
      where: where(AccessPolicyRule.t),
      orderBy: orderBy?.call(AccessPolicyRule.t),
      orderByList: orderByList?.call(AccessPolicyRule.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AccessPolicyRuleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AccessPolicyRule>(
      where: where?.call(AccessPolicyRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AccessPolicyRule] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AccessPolicyRuleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AccessPolicyRule>(
      where: where(AccessPolicyRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AccessPolicyRuleAttachRowRepository {
  const AccessPolicyRuleAttachRowRepository._();

  /// Creates a relation between the given [AccessPolicyRule] and [AccessPolicy]
  /// by setting the [AccessPolicyRule]'s foreign key `policyId` to refer to the [AccessPolicy].
  Future<void> policy(
    _is.DatabaseSession session,
    AccessPolicyRule accessPolicyRule,
    _iesob2yd.AccessPolicy policy, {
    _is.Transaction? transaction,
  }) async {
    if (accessPolicyRule.id == null) {
      throw ArgumentError.notNull('accessPolicyRule.id');
    }
    if (policy.id == null) {
      throw ArgumentError.notNull('policy.id');
    }

    var $accessPolicyRule = accessPolicyRule.copyWith(policyId: policy.id);
    await session.db.updateRow<AccessPolicyRule>(
      $accessPolicyRule,
      columns: [AccessPolicyRule.t.policyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccessPolicyRule] and [DoorDevice]
  /// by setting the [AccessPolicyRule]'s foreign key `deviceId` to refer to the [DoorDevice].
  Future<void> device(
    _is.DatabaseSession session,
    AccessPolicyRule accessPolicyRule,
    _i3q1tj4m.DoorDevice device, {
    _is.Transaction? transaction,
  }) async {
    if (accessPolicyRule.id == null) {
      throw ArgumentError.notNull('accessPolicyRule.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $accessPolicyRule = accessPolicyRule.copyWith(deviceId: device.id);
    await session.db.updateRow<AccessPolicyRule>(
      $accessPolicyRule,
      columns: [AccessPolicyRule.t.deviceId],
      transaction: transaction,
    );
  }
}

class AccessPolicyRuleDetachRowRepository {
  const AccessPolicyRuleDetachRowRepository._();

  /// Detaches the relation between this [AccessPolicyRule] and the [DoorDevice] set in `device`
  /// by setting the [AccessPolicyRule]'s foreign key `deviceId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> device(
    _is.DatabaseSession session,
    AccessPolicyRule accessPolicyRule, {
    _is.Transaction? transaction,
  }) async {
    if (accessPolicyRule.id == null) {
      throw ArgumentError.notNull('accessPolicyRule.id');
    }

    var $accessPolicyRule = accessPolicyRule.copyWith(deviceId: null);
    await session.db.updateRow<AccessPolicyRule>(
      $accessPolicyRule,
      columns: [AccessPolicyRule.t.deviceId],
      transaction: transaction,
    );
  }
}
