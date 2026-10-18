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

/// One doorinterface (ESP32) in the site's LAN, registered by the local
/// admin. MVP: LAN-only, manually managed — the address is entered by
/// hand (IP or hostname incl. local network domain, optional port); the
/// server calls the device's HTTP API from here.
abstract class DoorDevice
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoorDevice._({
    this.id,
    required this.name,
    required this.address,
    this.mac,
    this.configuredAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DoorDevice({
    int? id,
    required String name,
    required String address,
    String? mac,
    DateTime? configuredAt,
    DateTime? createdAt,
  }) = _DoorDeviceImpl;

  factory DoorDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoorDevice(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] as String,
      mac: jsonSerialization['mac'] as String?,
      configuredAt: jsonSerialization['configuredAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['configuredAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DoorDeviceTable();

  static const db = DoorDeviceRepository._();

  @override
  int? id;

  /// Display name of the device (e.g. "Hauseingang"); free text.
  String name;

  /// Address as entered by the admin: `192.168.1.50`, `door-1a2b.local`,
  /// optionally `host:port` (leading scheme is stripped).
  String address;

  /// The device's BLE MAC (reported in the config-push ACK) — used to
  /// attribute access-log entries to a registered device.
  String? mac;

  /// When the backend config (serverUrl + siteId) was last pushed to the
  /// device successfully (null = not yet configured).
  DateTime? configuredAt;

  /// When the device row was created.
  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoorDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoorDevice copyWith({
    int? id,
    String? name,
    String? address,
    String? mac,
    DateTime? configuredAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoorDevice',
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      if (mac != null) 'mac': mac,
      if (configuredAt != null) 'configuredAt': configuredAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoorDevice',
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      if (mac != null) 'mac': mac,
      if (configuredAt != null) 'configuredAt': configuredAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static DoorDeviceInclude include() {
    return DoorDeviceInclude._();
  }

  static DoorDeviceIncludeList includeList({
    _is.WhereExpressionBuilder<DoorDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorDeviceTable>? orderBy,
    _is.OrderByListBuilder<DoorDeviceTable>? orderByList,
    DoorDeviceInclude? include,
  }) {
    return DoorDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoorDevice.t),
      orderByList: orderByList?.call(DoorDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoorDeviceImpl extends DoorDevice {
  _DoorDeviceImpl({
    int? id,
    required String name,
    required String address,
    String? mac,
    DateTime? configuredAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         address: address,
         mac: mac,
         configuredAt: configuredAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DoorDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoorDevice copyWith({
    Object? id = _Undefined,
    String? name,
    String? address,
    Object? mac = _Undefined,
    Object? configuredAt = _Undefined,
    DateTime? createdAt,
  }) {
    return DoorDevice(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      mac: mac is String? ? mac : this.mac,
      configuredAt: configuredAt is DateTime?
          ? configuredAt
          : this.configuredAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DoorDeviceUpdateTable extends _is.UpdateTable<DoorDeviceTable> {
  DoorDeviceUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> address(String value) => _is.ColumnValue(
    table.address,
    value,
  );

  _is.ColumnValue<String, String> mac(String? value) => _is.ColumnValue(
    table.mac,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> configuredAt(DateTime? value) =>
      _is.ColumnValue(
        table.configuredAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DoorDeviceTable extends _is.Table<int?> {
  DoorDeviceTable({super.tableRelation}) : super(tableName: 'door_devices') {
    updateTable = DoorDeviceUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    address = _is.ColumnString(
      'address',
      this,
    );
    mac = _is.ColumnString(
      'mac',
      this,
    );
    configuredAt = _is.ColumnDateTime(
      'configuredAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DoorDeviceUpdateTable updateTable;

  /// Display name of the device (e.g. "Hauseingang"); free text.
  late final _is.ColumnString name;

  /// Address as entered by the admin: `192.168.1.50`, `door-1a2b.local`,
  /// optionally `host:port` (leading scheme is stripped).
  late final _is.ColumnString address;

  /// The device's BLE MAC (reported in the config-push ACK) — used to
  /// attribute access-log entries to a registered device.
  late final _is.ColumnString mac;

  /// When the backend config (serverUrl + siteId) was last pushed to the
  /// device successfully (null = not yet configured).
  late final _is.ColumnDateTime configuredAt;

  /// When the device row was created.
  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    address,
    mac,
    configuredAt,
    createdAt,
  ];
}

class DoorDeviceInclude extends _is.IncludeObject {
  DoorDeviceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoorDevice.t;
}

class DoorDeviceIncludeList extends _is.IncludeList {
  DoorDeviceIncludeList._({
    _is.WhereExpressionBuilder<DoorDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoorDevice.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoorDevice.t;
}

class DoorDeviceRepository {
  const DoorDeviceRepository._();

  /// Returns a list of [DoorDevice]s matching the given query parameters.
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
  Future<List<DoorDevice>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorDeviceTable>? orderBy,
    _is.OrderByListBuilder<DoorDeviceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoorDevice>(
      where: where?.call(DoorDevice.t),
      orderBy: orderBy?.call(DoorDevice.t),
      orderByList: orderByList?.call(DoorDevice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoorDevice] matching the given query parameters.
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
  Future<DoorDevice?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorDeviceTable>? where,
    int? offset,
    _is.OrderByBuilder<DoorDeviceTable>? orderBy,
    _is.OrderByListBuilder<DoorDeviceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoorDevice>(
      where: where?.call(DoorDevice.t),
      orderBy: orderBy?.call(DoorDevice.t),
      orderByList: orderByList?.call(DoorDevice.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoorDevice] by its [id] or null if no such row exists.
  Future<DoorDevice?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoorDevice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoorDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [DoorDevice]s will have their `id` fields set.
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
  Future<List<DoorDevice>> insert(
    _is.DatabaseSession session,
    List<DoorDevice> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoorDevice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoorDevice] and returns the inserted row.
  ///
  /// The returned [DoorDevice] will have its `id` field set.
  Future<DoorDevice> insertRow(
    _is.DatabaseSession session,
    DoorDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoorDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoorDevice]s in the list and returns the resulting rows.
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
  /// The returned [DoorDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorDevice>> upsert(
    _is.DatabaseSession session,
    List<DoorDevice> rows, {
    required _is.ColumnSelections<DoorDeviceTable> conflictColumns,
    _is.ColumnSelections<DoorDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<DoorDeviceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoorDevice>(
      rows,
      conflictColumns: conflictColumns(DoorDevice.t),
      updateColumns: updateColumns?.call(DoorDevice.t),
      updateWhere: updateWhere?.call(DoorDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoorDevice] and returns the resulting row.
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
  /// The returned [DoorDevice] will have its `id` field set.
  Future<DoorDevice?> upsertRow(
    _is.DatabaseSession session,
    DoorDevice row, {
    required _is.ColumnSelections<DoorDeviceTable> conflictColumns,
    _is.ColumnSelections<DoorDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<DoorDeviceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoorDevice>(
      row,
      conflictColumns: conflictColumns(DoorDevice.t),
      updateColumns: updateColumns?.call(DoorDevice.t),
      updateWhere: updateWhere?.call(DoorDevice.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoorDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorDevice>> update(
    _is.DatabaseSession session,
    List<DoorDevice> rows, {
    _is.ColumnSelections<DoorDeviceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoorDevice>(
      rows,
      columns: columns?.call(DoorDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoorDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoorDevice> updateRow(
    _is.DatabaseSession session,
    DoorDevice row, {
    _is.ColumnSelections<DoorDeviceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoorDevice>(
      row,
      columns: columns?.call(DoorDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoorDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoorDevice?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoorDeviceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoorDevice>(
      id,
      columnValues: columnValues(DoorDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoorDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoorDevice>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoorDeviceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DoorDeviceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoorDeviceTable>? orderBy,
    _is.OrderByListBuilder<DoorDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoorDevice>(
      columnValues: columnValues(DoorDevice.t.updateTable),
      where: where(DoorDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoorDevice.t),
      orderByList: orderByList?.call(DoorDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoorDevice]s in the list and returns the deleted rows.
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
  Future<List<DoorDevice>> delete(
    _is.DatabaseSession session,
    List<DoorDevice> rows, {
    _is.OrderByBuilder<DoorDeviceTable>? orderBy,
    _is.OrderByListBuilder<DoorDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoorDevice>(
      rows,
      orderBy: orderBy?.call(DoorDevice.t),
      orderByList: orderByList?.call(DoorDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoorDevice].
  Future<DoorDevice> deleteRow(
    _is.DatabaseSession session,
    DoorDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoorDevice>(
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
  Future<List<DoorDevice>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoorDeviceTable> where,
    _is.OrderByBuilder<DoorDeviceTable>? orderBy,
    _is.OrderByListBuilder<DoorDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoorDevice>(
      where: where(DoorDevice.t),
      orderBy: orderBy?.call(DoorDevice.t),
      orderByList: orderByList?.call(DoorDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoorDeviceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoorDevice>(
      where: where?.call(DoorDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoorDevice] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoorDeviceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoorDevice>(
      where: where(DoorDevice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
