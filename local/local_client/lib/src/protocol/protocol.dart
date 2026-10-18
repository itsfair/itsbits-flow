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
import 'package:local_client/src/protocol/door/door_device.dart' as _izp9nmgv;
import 'package:local_client/src/protocol/door/door_policy_rule_data.dart'
    as _iwojdmzr;
import 'package:local_client/src/protocol/door/door_policy_summary.dart'
    as _im48e7m8;
import 'package:local_client/src/protocol/door/member_policy_assignment_data.dart'
    as _iswvz4vf;
import 'package:local_client/src/protocol/site/member_summary.dart'
    as _i5ndcnpn;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'door/access_policy.dart' as _iyo2ksr9;
import 'door/access_policy_member.dart' as _i8ui35gp;
import 'door/access_policy_rule.dart' as _ifutk4wd;
import 'door/door_access_consumed.dart' as _itva5m08;
import 'door/door_access_log.dart' as _if5sm73w;
import 'door/door_access_result.dart' as _imylpxds;
import 'door/door_device.dart' as _iwj06at4;
import 'door/door_device_exception.dart' as _ie1804l2;
import 'door/door_device_push_result.dart' as _i6xa9yhs;
import 'door/door_device_status.dart' as _idztj6dr;
import 'door/door_policy_detail.dart' as _i88m2ve9;
import 'door/door_policy_member_data.dart' as _ifbo0khc;
import 'door/door_policy_rule_data.dart' as _i80j1go4;
import 'door/door_policy_summary.dart' as _ihr7ucho;
import 'door/member_policy_assignment_data.dart' as _i4v4a6vw;
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
export 'door/access_policy.dart';
export 'door/access_policy_member.dart';
export 'door/access_policy_rule.dart';
export 'door/door_access_consumed.dart';
export 'door/door_access_log.dart';
export 'door/door_access_result.dart';
export 'door/door_device.dart';
export 'door/door_device_exception.dart';
export 'door/door_device_push_result.dart';
export 'door/door_device_status.dart';
export 'door/door_policy_detail.dart';
export 'door/door_policy_member_data.dart';
export 'door/door_policy_rule_data.dart';
export 'door/door_policy_summary.dart';
export 'door/member_policy_assignment_data.dart';
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
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iyo2ksr9.AccessPolicy) {
      return _iyo2ksr9.AccessPolicy.fromJson(data) as T;
    }
    if (t == _i8ui35gp.AccessPolicyMember) {
      return _i8ui35gp.AccessPolicyMember.fromJson(data) as T;
    }
    if (t == _ifutk4wd.AccessPolicyRule) {
      return _ifutk4wd.AccessPolicyRule.fromJson(data) as T;
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
    if (t == _i88m2ve9.DoorPolicyDetail) {
      return _i88m2ve9.DoorPolicyDetail.fromJson(data) as T;
    }
    if (t == _ifbo0khc.DoorPolicyMemberData) {
      return _ifbo0khc.DoorPolicyMemberData.fromJson(data) as T;
    }
    if (t == _i80j1go4.DoorPolicyRuleData) {
      return _i80j1go4.DoorPolicyRuleData.fromJson(data) as T;
    }
    if (t == _ihr7ucho.DoorPolicySummary) {
      return _ihr7ucho.DoorPolicySummary.fromJson(data) as T;
    }
    if (t == _i4v4a6vw.MemberPolicyAssignmentData) {
      return _i4v4a6vw.MemberPolicyAssignmentData.fromJson(data) as T;
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
    if (t == _isc.getType<_iyo2ksr9.AccessPolicy?>()) {
      return (data != null ? _iyo2ksr9.AccessPolicy.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8ui35gp.AccessPolicyMember?>()) {
      return (data != null ? _i8ui35gp.AccessPolicyMember.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifutk4wd.AccessPolicyRule?>()) {
      return (data != null ? _ifutk4wd.AccessPolicyRule.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itva5m08.DoorAccessConsumed?>()) {
      return (data != null ? _itva5m08.DoorAccessConsumed.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_if5sm73w.DoorAccessLog?>()) {
      return (data != null ? _if5sm73w.DoorAccessLog.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imylpxds.DoorAccessResult?>()) {
      return (data != null ? _imylpxds.DoorAccessResult.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iwj06at4.DoorDevice?>()) {
      return (data != null ? _iwj06at4.DoorDevice.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie1804l2.DoorDeviceException?>()) {
      return (data != null
              ? _ie1804l2.DoorDeviceException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i6xa9yhs.DoorDevicePushResult?>()) {
      return (data != null
              ? _i6xa9yhs.DoorDevicePushResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idztj6dr.DoorDeviceStatus?>()) {
      return (data != null ? _idztj6dr.DoorDeviceStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i88m2ve9.DoorPolicyDetail?>()) {
      return (data != null ? _i88m2ve9.DoorPolicyDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifbo0khc.DoorPolicyMemberData?>()) {
      return (data != null
              ? _ifbo0khc.DoorPolicyMemberData.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i80j1go4.DoorPolicyRuleData?>()) {
      return (data != null ? _i80j1go4.DoorPolicyRuleData.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihr7ucho.DoorPolicySummary?>()) {
      return (data != null ? _ihr7ucho.DoorPolicySummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4v4a6vw.MemberPolicyAssignmentData?>()) {
      return (data != null
              ? _i4v4a6vw.MemberPolicyAssignmentData.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_isettk53.LocalAdminInfo?>()) {
      return (data != null ? _isettk53.LocalAdminInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibduyanx.MemberDetail?>()) {
      return (data != null ? _ibduyanx.MemberDetail.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7xewumy.MemberMembership?>()) {
      return (data != null ? _i7xewumy.MemberMembership.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv3515ms.MemberProfile?>()) {
      return (data != null ? _iv3515ms.MemberProfile.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_im7fwdsr.MemberRole?>()) {
      return (data != null ? _im7fwdsr.MemberRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipy883wg.MemberSummary?>()) {
      return (data != null ? _ipy883wg.MemberSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iin2gxgd.SiteCandidateLocal?>()) {
      return (data != null ? _iin2gxgd.SiteCandidateLocal.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_irwm5040.SiteConnection?>()) {
      return (data != null ? _irwm5040.SiteConnection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i9oolunz.SiteConnectionInfo?>()) {
      return (data != null ? _i9oolunz.SiteConnectionInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifrxdjdr.SiteConnectionState?>()) {
      return (data != null
              ? _ifrxdjdr.SiteConnectionState.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_imfczqeb.SiteSetupException?>()) {
      return (data != null ? _imfczqeb.SiteSetupException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_in5mc098.SiteSetupResult?>()) {
      return (data != null ? _in5mc098.SiteSetupResult.fromJson(data) : null)
          as T;
    }
    if (t == List<_i80j1go4.DoorPolicyRuleData>) {
      return (data as List)
              .map((e) => deserialize<_i80j1go4.DoorPolicyRuleData>(e))
              .toList()
          as T;
    }
    if (t == List<_ifbo0khc.DoorPolicyMemberData>) {
      return (data as List)
              .map((e) => deserialize<_ifbo0khc.DoorPolicyMemberData>(e))
              .toList()
          as T;
    }
    if (t == List<_iin2gxgd.SiteCandidateLocal>) {
      return (data as List)
              .map((e) => deserialize<_iin2gxgd.SiteCandidateLocal>(e))
              .toList()
          as T;
    }
    if (t == List<_izp9nmgv.DoorDevice>) {
      return (data as List)
              .map((e) => deserialize<_izp9nmgv.DoorDevice>(e))
              .toList()
          as T;
    }
    if (t == List<_im48e7m8.DoorPolicySummary>) {
      return (data as List)
              .map((e) => deserialize<_im48e7m8.DoorPolicySummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iwojdmzr.DoorPolicyRuleData>) {
      return (data as List)
              .map((e) => deserialize<_iwojdmzr.DoorPolicyRuleData>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_iswvz4vf.MemberPolicyAssignmentData>) {
      return (data as List)
              .map((e) => deserialize<_iswvz4vf.MemberPolicyAssignmentData>(e))
              .toList()
          as T;
    }
    if (t == List<_i5ndcnpn.MemberSummary>) {
      return (data as List)
              .map((e) => deserialize<_i5ndcnpn.MemberSummary>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iyo2ksr9.AccessPolicy => 'AccessPolicy',
      _i8ui35gp.AccessPolicyMember => 'AccessPolicyMember',
      _ifutk4wd.AccessPolicyRule => 'AccessPolicyRule',
      _itva5m08.DoorAccessConsumed => 'DoorAccessConsumed',
      _if5sm73w.DoorAccessLog => 'DoorAccessLog',
      _imylpxds.DoorAccessResult => 'DoorAccessResult',
      _iwj06at4.DoorDevice => 'DoorDevice',
      _ie1804l2.DoorDeviceException => 'DoorDeviceException',
      _i6xa9yhs.DoorDevicePushResult => 'DoorDevicePushResult',
      _idztj6dr.DoorDeviceStatus => 'DoorDeviceStatus',
      _i88m2ve9.DoorPolicyDetail => 'DoorPolicyDetail',
      _ifbo0khc.DoorPolicyMemberData => 'DoorPolicyMemberData',
      _i80j1go4.DoorPolicyRuleData => 'DoorPolicyRuleData',
      _ihr7ucho.DoorPolicySummary => 'DoorPolicySummary',
      _i4v4a6vw.MemberPolicyAssignmentData => 'MemberPolicyAssignmentData',
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
      case _iyo2ksr9.AccessPolicy():
        return 'AccessPolicy';
      case _i8ui35gp.AccessPolicyMember():
        return 'AccessPolicyMember';
      case _ifutk4wd.AccessPolicyRule():
        return 'AccessPolicyRule';
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
      case _i88m2ve9.DoorPolicyDetail():
        return 'DoorPolicyDetail';
      case _ifbo0khc.DoorPolicyMemberData():
        return 'DoorPolicyMemberData';
      case _i80j1go4.DoorPolicyRuleData():
        return 'DoorPolicyRuleData';
      case _ihr7ucho.DoorPolicySummary():
        return 'DoorPolicySummary';
      case _i4v4a6vw.MemberPolicyAssignmentData():
        return 'MemberPolicyAssignmentData';
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
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessPolicy') {
      return deserialize<_iyo2ksr9.AccessPolicy>(data['data']);
    }
    if (dataClassName == 'AccessPolicyMember') {
      return deserialize<_i8ui35gp.AccessPolicyMember>(data['data']);
    }
    if (dataClassName == 'AccessPolicyRule') {
      return deserialize<_ifutk4wd.AccessPolicyRule>(data['data']);
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
    if (dataClassName == 'DoorPolicyDetail') {
      return deserialize<_i88m2ve9.DoorPolicyDetail>(data['data']);
    }
    if (dataClassName == 'DoorPolicyMemberData') {
      return deserialize<_ifbo0khc.DoorPolicyMemberData>(data['data']);
    }
    if (dataClassName == 'DoorPolicyRuleData') {
      return deserialize<_i80j1go4.DoorPolicyRuleData>(data['data']);
    }
    if (dataClassName == 'DoorPolicySummary') {
      return deserialize<_ihr7ucho.DoorPolicySummary>(data['data']);
    }
    if (dataClassName == 'MemberPolicyAssignmentData') {
      return deserialize<_i4v4a6vw.MemberPolicyAssignmentData>(data['data']);
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
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('local', this);
    _iacc.Protocol().registerHostProtocol('local', this);
  }

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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
