/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:local_server/src/generated/door/door_device.dart' as _iu3d9h1r;
import 'package:local_server/src/generated/site/member_summary.dart'
    as _in3590t5;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'door/door_access_consumed.dart' as _itva5m08;
import 'door/door_access_log.dart' as _if5sm73w;
import 'door/door_access_result.dart' as _imylpxds;
import 'door/door_device.dart' as _iwj06at4;
import 'door/door_device_exception.dart' as _ie1804l2;
import 'door/door_device_push_result.dart' as _i6xa9yhs;
import 'door/door_device_status.dart' as _idztj6dr;
import 'site/local_admin_info.dart' as _isettk53;
import 'site/member_detail.dart' as _ibduyanx;
import 'site/member_membership.dart' as _i7xewumy;
import 'site/member_profile.dart' as _iv3515ms;
import 'site/member_role.dart' as _im7fwdsr;
import 'site/member_summary.dart' as _ipy883wg;
import 'site/site_candidate_local.dart' as _iin2gxgd;
import 'site/site_connection.dart' as _irwm5040;
import 'site/site_connection_info.dart' as _i9oolunz;
import 'site/site_connection_state.dart' as _ifrxdjdr;
import 'site/site_setup_exception.dart' as _imfczqeb;
import 'site/site_setup_result.dart' as _in5mc098;
export 'door/door_access_consumed.dart';
export 'door/door_access_log.dart';
export 'door/door_access_result.dart';
export 'door/door_device.dart';
export 'door/door_device_exception.dart';
export 'door/door_device_push_result.dart';
export 'door/door_device_status.dart';
export 'site/local_admin_info.dart';
export 'site/member_detail.dart';
export 'site/member_membership.dart';
export 'site/member_profile.dart';
export 'site/member_role.dart';
export 'site/member_summary.dart';
export 'site/site_candidate_local.dart';
export 'site/site_connection.dart';
export 'site/site_connection_info.dart';
export 'site/site_connection_state.dart';
export 'site/site_setup_exception.dart';
export 'site/site_setup_result.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'door_access_consumed',
      dartName: 'DoorAccessConsumed',
      schema: 'public',
      module: 'local',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userKey',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'step',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'door_access_consumed_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userKey',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'step',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'door_access_logs',
      dartName: 'DoorAccessLog',
      schema: 'public',
      module: 'local',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'deviceMac',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'userKey',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'result',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DoorAccessResult',
        ),
        _isp.ColumnDefinition(
          name: 'detail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'door_access_logs_user_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userKey',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'door_access_logs_result_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'result',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'door_devices',
      dartName: 'DoorDevice',
      schema: 'public',
      module: 'local',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'mac',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'configuredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'door_devices_address_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'address',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'member_memberships',
      dartName: 'MemberMembership',
      schema: 'public',
      module: 'local',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'memberProfileId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'globalAuthUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MemberRole',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'endedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'member_memberships_fk_0',
          columns: ['memberProfileId'],
          referenceTable: 'member_profile',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'member_membership_profile_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'memberProfileId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'member_membership_global_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'globalAuthUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'member_profile',
      dartName: 'MemberProfile',
      schema: 'public',
      module: 'local',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'globalAuthUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'firstName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'lastName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'birthday',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'imageUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'doorCodeSecret',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'member_profile_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'member_profile_auth_user_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'member_profile_global_auth_user_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'globalAuthUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'site_connections',
      dartName: 'SiteConnection',
      schema: 'public',
      module: 'local',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'globalApiUrl',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'siteId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'siteName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'siteStreet',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'siteZipCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'siteCity',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'siteCountry',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'siteCompanyEmail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'siteImageUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'adminAuthUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'deviceSessionKey',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'enrolledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _itva5m08.DoorAccessConsumed) {
      return _itva5m08.DoorAccessConsumed.fromJson(data) as T;
    }
    if (t == _if5sm73w.DoorAccessLog) {
      return _if5sm73w.DoorAccessLog.fromJson(data) as T;
    }
    if (t == _imylpxds.DoorAccessResult) {
      return _imylpxds.DoorAccessResult.fromJson(data) as T;
    }
    if (t == _iwj06at4.DoorDevice) {
      return _iwj06at4.DoorDevice.fromJson(data) as T;
    }
    if (t == _ie1804l2.DoorDeviceException) {
      return _ie1804l2.DoorDeviceException.fromJson(data) as T;
    }
    if (t == _i6xa9yhs.DoorDevicePushResult) {
      return _i6xa9yhs.DoorDevicePushResult.fromJson(data) as T;
    }
    if (t == _idztj6dr.DoorDeviceStatus) {
      return _idztj6dr.DoorDeviceStatus.fromJson(data) as T;
    }
    if (t == _isettk53.LocalAdminInfo) {
      return _isettk53.LocalAdminInfo.fromJson(data) as T;
    }
    if (t == _ibduyanx.MemberDetail) {
      return _ibduyanx.MemberDetail.fromJson(data) as T;
    }
    if (t == _i7xewumy.MemberMembership) {
      return _i7xewumy.MemberMembership.fromJson(data) as T;
    }
    if (t == _iv3515ms.MemberProfile) {
      return _iv3515ms.MemberProfile.fromJson(data) as T;
    }
    if (t == _im7fwdsr.MemberRole) {
      return _im7fwdsr.MemberRole.fromJson(data) as T;
    }
    if (t == _ipy883wg.MemberSummary) {
      return _ipy883wg.MemberSummary.fromJson(data) as T;
    }
    if (t == _iin2gxgd.SiteCandidateLocal) {
      return _iin2gxgd.SiteCandidateLocal.fromJson(data) as T;
    }
    if (t == _irwm5040.SiteConnection) {
      return _irwm5040.SiteConnection.fromJson(data) as T;
    }
    if (t == _i9oolunz.SiteConnectionInfo) {
      return _i9oolunz.SiteConnectionInfo.fromJson(data) as T;
    }
    if (t == _ifrxdjdr.SiteConnectionState) {
      return _ifrxdjdr.SiteConnectionState.fromJson(data) as T;
    }
    if (t == _imfczqeb.SiteSetupException) {
      return _imfczqeb.SiteSetupException.fromJson(data) as T;
    }
    if (t == _in5mc098.SiteSetupResult) {
      return _in5mc098.SiteSetupResult.fromJson(data) as T;
    }
    if (t == _is.getType<_itva5m08.DoorAccessConsumed?>()) {
      return (data != null ? _itva5m08.DoorAccessConsumed.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if5sm73w.DoorAccessLog?>()) {
      return (data != null ? _if5sm73w.DoorAccessLog.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imylpxds.DoorAccessResult?>()) {
      return (data != null ? _imylpxds.DoorAccessResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iwj06at4.DoorDevice?>()) {
      return (data != null ? _iwj06at4.DoorDevice.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie1804l2.DoorDeviceException?>()) {
      return (data != null
              ? _ie1804l2.DoorDeviceException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i6xa9yhs.DoorDevicePushResult?>()) {
      return (data != null
              ? _i6xa9yhs.DoorDevicePushResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_idztj6dr.DoorDeviceStatus?>()) {
      return (data != null ? _idztj6dr.DoorDeviceStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isettk53.LocalAdminInfo?>()) {
      return (data != null ? _isettk53.LocalAdminInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibduyanx.MemberDetail?>()) {
      return (data != null ? _ibduyanx.MemberDetail.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7xewumy.MemberMembership?>()) {
      return (data != null ? _i7xewumy.MemberMembership.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv3515ms.MemberProfile?>()) {
      return (data != null ? _iv3515ms.MemberProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_im7fwdsr.MemberRole?>()) {
      return (data != null ? _im7fwdsr.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipy883wg.MemberSummary?>()) {
      return (data != null ? _ipy883wg.MemberSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iin2gxgd.SiteCandidateLocal?>()) {
      return (data != null ? _iin2gxgd.SiteCandidateLocal.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irwm5040.SiteConnection?>()) {
      return (data != null ? _irwm5040.SiteConnection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9oolunz.SiteConnectionInfo?>()) {
      return (data != null ? _i9oolunz.SiteConnectionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifrxdjdr.SiteConnectionState?>()) {
      return (data != null
              ? _ifrxdjdr.SiteConnectionState.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_imfczqeb.SiteSetupException?>()) {
      return (data != null ? _imfczqeb.SiteSetupException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_in5mc098.SiteSetupResult?>()) {
      return (data != null ? _in5mc098.SiteSetupResult.fromJson(data) : null)
          as T;
    }
    if (t == List<_iin2gxgd.SiteCandidateLocal>) {
      return (data as List)
              .map((e) => deserialize<_iin2gxgd.SiteCandidateLocal>(e))
              .toList()
          as T;
    }
    if (t == List<_iu3d9h1r.DoorDevice>) {
      return (data as List)
              .map((e) => deserialize<_iu3d9h1r.DoorDevice>(e))
              .toList()
          as T;
    }
    if (t == List<_in3590t5.MemberSummary>) {
      return (data as List)
              .map((e) => deserialize<_in3590t5.MemberSummary>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _itva5m08.DoorAccessConsumed => 'DoorAccessConsumed',
      _if5sm73w.DoorAccessLog => 'DoorAccessLog',
      _imylpxds.DoorAccessResult => 'DoorAccessResult',
      _iwj06at4.DoorDevice => 'DoorDevice',
      _ie1804l2.DoorDeviceException => 'DoorDeviceException',
      _i6xa9yhs.DoorDevicePushResult => 'DoorDevicePushResult',
      _idztj6dr.DoorDeviceStatus => 'DoorDeviceStatus',
      _isettk53.LocalAdminInfo => 'LocalAdminInfo',
      _ibduyanx.MemberDetail => 'MemberDetail',
      _i7xewumy.MemberMembership => 'MemberMembership',
      _iv3515ms.MemberProfile => 'MemberProfile',
      _im7fwdsr.MemberRole => 'MemberRole',
      _ipy883wg.MemberSummary => 'MemberSummary',
      _iin2gxgd.SiteCandidateLocal => 'SiteCandidateLocal',
      _irwm5040.SiteConnection => 'SiteConnection',
      _i9oolunz.SiteConnectionInfo => 'SiteConnectionInfo',
      _ifrxdjdr.SiteConnectionState => 'SiteConnectionState',
      _imfczqeb.SiteSetupException => 'SiteSetupException',
      _in5mc098.SiteSetupResult => 'SiteSetupResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('local.', '');
    }

    switch (data) {
      case _itva5m08.DoorAccessConsumed():
        return 'DoorAccessConsumed';
      case _if5sm73w.DoorAccessLog():
        return 'DoorAccessLog';
      case _imylpxds.DoorAccessResult():
        return 'DoorAccessResult';
      case _iwj06at4.DoorDevice():
        return 'DoorDevice';
      case _ie1804l2.DoorDeviceException():
        return 'DoorDeviceException';
      case _i6xa9yhs.DoorDevicePushResult():
        return 'DoorDevicePushResult';
      case _idztj6dr.DoorDeviceStatus():
        return 'DoorDeviceStatus';
      case _isettk53.LocalAdminInfo():
        return 'LocalAdminInfo';
      case _ibduyanx.MemberDetail():
        return 'MemberDetail';
      case _i7xewumy.MemberMembership():
        return 'MemberMembership';
      case _iv3515ms.MemberProfile():
        return 'MemberProfile';
      case _im7fwdsr.MemberRole():
        return 'MemberRole';
      case _ipy883wg.MemberSummary():
        return 'MemberSummary';
      case _iin2gxgd.SiteCandidateLocal():
        return 'SiteCandidateLocal';
      case _irwm5040.SiteConnection():
        return 'SiteConnection';
      case _i9oolunz.SiteConnectionInfo():
        return 'SiteConnectionInfo';
      case _ifrxdjdr.SiteConnectionState():
        return 'SiteConnectionState';
      case _imfczqeb.SiteSetupException():
        return 'SiteSetupException';
      case _in5mc098.SiteSetupResult():
        return 'SiteSetupResult';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DoorAccessConsumed') {
      return deserialize<_itva5m08.DoorAccessConsumed>(data['data']);
    }
    if (dataClassName == 'DoorAccessLog') {
      return deserialize<_if5sm73w.DoorAccessLog>(data['data']);
    }
    if (dataClassName == 'DoorAccessResult') {
      return deserialize<_imylpxds.DoorAccessResult>(data['data']);
    }
    if (dataClassName == 'DoorDevice') {
      return deserialize<_iwj06at4.DoorDevice>(data['data']);
    }
    if (dataClassName == 'DoorDeviceException') {
      return deserialize<_ie1804l2.DoorDeviceException>(data['data']);
    }
    if (dataClassName == 'DoorDevicePushResult') {
      return deserialize<_i6xa9yhs.DoorDevicePushResult>(data['data']);
    }
    if (dataClassName == 'DoorDeviceStatus') {
      return deserialize<_idztj6dr.DoorDeviceStatus>(data['data']);
    }
    if (dataClassName == 'LocalAdminInfo') {
      return deserialize<_isettk53.LocalAdminInfo>(data['data']);
    }
    if (dataClassName == 'MemberDetail') {
      return deserialize<_ibduyanx.MemberDetail>(data['data']);
    }
    if (dataClassName == 'MemberMembership') {
      return deserialize<_i7xewumy.MemberMembership>(data['data']);
    }
    if (dataClassName == 'MemberProfile') {
      return deserialize<_iv3515ms.MemberProfile>(data['data']);
    }
    if (dataClassName == 'MemberRole') {
      return deserialize<_im7fwdsr.MemberRole>(data['data']);
    }
    if (dataClassName == 'MemberSummary') {
      return deserialize<_ipy883wg.MemberSummary>(data['data']);
    }
    if (dataClassName == 'SiteCandidateLocal') {
      return deserialize<_iin2gxgd.SiteCandidateLocal>(data['data']);
    }
    if (dataClassName == 'SiteConnection') {
      return deserialize<_irwm5040.SiteConnection>(data['data']);
    }
    if (dataClassName == 'SiteConnectionInfo') {
      return deserialize<_i9oolunz.SiteConnectionInfo>(data['data']);
    }
    if (dataClassName == 'SiteConnectionState') {
      return deserialize<_ifrxdjdr.SiteConnectionState>(data['data']);
    }
    if (dataClassName == 'SiteSetupException') {
      return deserialize<_imfczqeb.SiteSetupException>(data['data']);
    }
    if (dataClassName == 'SiteSetupResult') {
      return deserialize<_in5mc098.SiteSetupResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('local', this);
    _iacs.Protocol().registerHostProtocol('local', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _itva5m08.DoorAccessConsumed:
        return _itva5m08.DoorAccessConsumed.t;
      case _if5sm73w.DoorAccessLog:
        return _if5sm73w.DoorAccessLog.t;
      case _iwj06at4.DoorDevice:
        return _iwj06at4.DoorDevice.t;
      case _i7xewumy.MemberMembership:
        return _i7xewumy.MemberMembership.t;
      case _iv3515ms.MemberProfile:
        return _iv3515ms.MemberProfile.t;
      case _irwm5040.SiteConnection:
        return _irwm5040.SiteConnection.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'local';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
