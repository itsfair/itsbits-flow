import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../site/global_site_connection.dart';

/// Admin endpoint for the access policies ("Zugangsberechtigung").
/// Deny-by-default: a member may open a door ONLY while an active
/// assignment (with per-user validity period) points to a policy that
/// carries a rule granting this door on this weekday inside its minute
/// window. The verifier (`DoorAccessVerifier`) enforces this at every
/// request.
///
/// Value ranges: weekday 0=Monday..6=Sunday, startMinute 0-1439,
/// endMinute 1-1440 (exclusive; 1440 = midnight end). Overnight windows
/// are expressed as two rules (no wrap semantics).
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`),
/// same as membersAdmin/siteAdmin/doorDeviceAdmin.
class DoorPolicyAdminEndpoint extends Endpoint {
  @override
  Set<Scope> get requiredScopes => {const Scope(kLocalAdminScope)};

  /// All policies, newest first (with resolved rule/member counts).
  Future<List<DoorPolicySummary>> listPolicies(final Session session) async {
    final policies = await AccessPolicy.db.find(
      session,
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );
    final rules = await AccessPolicyRule.db.find(session);
    final assignments = await AccessPolicyMember.db.find(session);
    final ruleCounts = <int, int>{};
    for (final rule in rules) {
      ruleCounts[rule.policyId] = (ruleCounts[rule.policyId] ?? 0) + 1;
    }
    final memberCounts = <int, int>{};
    for (final assignment in assignments) {
      memberCounts[assignment.policyId] =
          (memberCounts[assignment.policyId] ?? 0) + 1;
    }
    return [
      for (final policy in policies)
        DoorPolicySummary(
          id: policy.id!,
          name: policy.name,
          ruleCount: ruleCounts[policy.id!] ?? 0,
          memberCount: memberCounts[policy.id!] ?? 0,
          createdAt: policy.createdAt,
        ),
    ];
  }

  /// One policy in full detail (rules with door names + assignments with
  /// person display fields).
  Future<DoorPolicyDetail> getPolicy(
    final Session session, {
    required final int id,
  }) async {
    final policy = await _requirePolicy(session, id);
    final rules = await AccessPolicyRule.db.find(
      session,
      where: (t) => t.policyId.equals(id),
      orderByList: (t) => [t.weekday.asc(), t.startMinute.asc()],
    );
    final deviceIds = rules.map((r) => r.deviceId).whereType<int>().toSet();
    final devices = deviceIds.isEmpty
        ? <DoorDevice>[]
        : await DoorDevice.db.find(
            session,
            where: (t) => t.id.inSet(deviceIds),
          );
    final deviceNames = {
      for (final device in devices) device.id!: device.name,
    };

    final assignments = await AccessPolicyMember.db.find(
      session,
      where: (t) => t.policyId.equals(id),
      orderByList: (t) => [t.validFrom.desc()],
    );
    final profileIds = assignments.map((a) => a.memberProfileId).toSet();
    final profiles = profileIds.isEmpty
        ? <MemberProfile>[]
        : await MemberProfile.db.find(
            session,
            where: (t) => t.id.inSet(profileIds),
          );
    final profilesById = {for (final p in profiles) p.id!: p};

    return DoorPolicyDetail(
      id: policy.id!,
      name: policy.name,
      createdAt: policy.createdAt,
      rules: [
        for (final rule in rules)
          DoorPolicyRuleData(
            id: rule.id!,
            deviceId: rule.deviceId,
            deviceName: rule.deviceId == null
                ? null
                : deviceNames[rule.deviceId],
            weekday: rule.weekday,
            startMinute: rule.startMinute,
            endMinute: rule.endMinute,
          ),
      ],
      members: [
        for (final assignment in assignments)
          DoorPolicyMemberData(
            id: assignment.id!,
            globalAuthUserId: assignment.globalAuthUserId,
            email: profilesById[assignment.memberProfileId]?.email ?? '',
            firstName: profilesById[assignment.memberProfileId]?.firstName,
            lastName: profilesById[assignment.memberProfileId]?.lastName,
            validFrom: assignment.validFrom,
            validUntil: assignment.validUntil,
          ),
      ],
    );
  }

  /// Creates a policy (name only — rules/members are added in the
  /// editor afterwards).
  Future<DoorPolicySummary> createPolicy(
    final Session session, {
    required final String name,
  }) async {
    final policy = await AccessPolicy.db.insertRow(
      session,
      AccessPolicy(name: _validateName(name)),
    );
    return DoorPolicySummary(
      id: policy.id!,
      name: policy.name,
      ruleCount: 0,
      memberCount: 0,
      createdAt: policy.createdAt,
    );
  }

  /// Renames a policy.
  Future<DoorPolicySummary> updatePolicy(
    final Session session, {
    required final int id,
    required final String name,
  }) async {
    final policy = await _requirePolicy(session, id);
    final updated = await AccessPolicy.db.updateRow(
      session,
      policy.copyWith(name: _validateName(name)),
    );
    final ruleCount = await AccessPolicyRule.db.count(
      session,
      where: (t) => t.policyId.equals(id),
    );
    final memberCount = await AccessPolicyMember.db.count(
      session,
      where: (t) => t.policyId.equals(id),
    );
    return DoorPolicySummary(
      id: updated.id!,
      name: updated.name,
      ruleCount: ruleCount,
      memberCount: memberCount,
      createdAt: updated.createdAt,
    );
  }

  /// Removes the policy (cascade deletes rules + assignments).
  Future<void> removePolicy(
    final Session session, {
    required final int id,
  }) async {
    final policy = await _requirePolicy(session, id);
    await AccessPolicy.db.deleteRow(session, policy);
  }

  /// Adds one rule per weekday ([weekdays] multi-select in the UI).
  Future<List<DoorPolicyRuleData>> addRule(
    final Session session, {
    required final int policyId,
    required final int? deviceId,
    required final List<int> weekdays,
    required final int startMinute,
    required final int endMinute,
  }) async {
    await _requirePolicy(session, policyId);
    final device = deviceId == null
        ? null
        : await _requireDevice(session, deviceId);
    _validateWindow(startMinute, endMinute);
    if (weekdays.isEmpty) {
      throw DoorDeviceException(message: 'Mindestens einen Wochentag wählen.');
    }
    for (final weekday in weekdays) {
      if (weekday < 0 || weekday > 6) {
        throw DoorDeviceException(message: 'Ungültiger Wochentag.');
      }
    }

    return [
      for (final weekday in weekdays)
        _toRuleData(
          await AccessPolicyRule.db.insertRow(
            session,
            AccessPolicyRule(
              policyId: policyId,
              deviceId: device?.id,
              weekday: weekday,
              startMinute: startMinute,
              endMinute: endMinute,
            ),
          ),
          deviceName: device?.name,
        ),
    ];
  }

  /// Updates one rule (door/weekday/window).
  Future<DoorPolicyRuleData> updateRule(
    final Session session, {
    required final int ruleId,
    required final int? deviceId,
    required final int weekday,
    required final int startMinute,
    required final int endMinute,
  }) async {
    final rule = await AccessPolicyRule.db.findById(session, ruleId);
    if (rule == null) {
      throw DoorDeviceException(message: 'Regel wurde nicht gefunden.');
    }
    final device = deviceId == null
        ? null
        : await _requireDevice(session, deviceId);
    _validateWindow(startMinute, endMinute);
    if (weekday < 0 || weekday > 6) {
      throw DoorDeviceException(message: 'Ungültiger Wochentag.');
    }
    final updated = await AccessPolicyRule.db.updateRow(
      session,
      rule.copyWith(
        deviceId: device?.id,
        weekday: weekday,
        startMinute: startMinute,
        endMinute: endMinute,
      ),
    );
    return _toRuleData(updated, deviceName: device?.name);
  }

  /// Removes one rule.
  Future<void> removeRule(
    final Session session, {
    required final int ruleId,
  }) async {
    final rule = await AccessPolicyRule.db.findById(session, ruleId);
    if (rule == null) {
      throw DoorDeviceException(message: 'Regel wurde nicht gefunden.');
    }
    await AccessPolicyRule.db.deleteRow(session, rule);
  }

  /// Assigns a member to a policy with a per-user validity period (the
  /// member is resolved by its exchange id — the UI works with the same
  /// id everywhere).
  Future<DoorPolicyMemberData> addMemberAssignment(
    final Session session, {
    required final int policyId,
    required final UuidValue globalAuthUserId,
    final DateTime? validFrom,
    final DateTime? validUntil,
  }) async {
    final policy = await _requirePolicy(session, policyId);
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.globalAuthUserId.equals(globalAuthUserId),
    );
    if (profile == null) {
      throw DoorDeviceException(message: 'Member wurde nicht gefunden.');
    }
    final from = validFrom ?? DateTime.now();
    _validateValidity(from, validUntil);

    final duplicate = await AccessPolicyMember.db.findFirstRow(
      session,
      where: (t) =>
          t.policyId.equals(policyId) &
          t.globalAuthUserId.equals(profile.globalAuthUserId),
    );
    if (duplicate != null) {
      throw DoorDeviceException(
        message: 'Dieses Mitglied hat diese Berechtigung bereits.',
      );
    }

    final assignment = await AccessPolicyMember.db.insertRow(
      session,
      AccessPolicyMember(
        policyId: policy.id!,
        memberProfileId: profile.id!,
        globalAuthUserId: profile.globalAuthUserId,
        validFrom: from,
        validUntil: validUntil,
      ),
    );
    return _toMemberData(assignment, profile);
  }

  /// Updates the validity period of one assignment.
  Future<DoorPolicyMemberData> updateMemberAssignment(
    final Session session, {
    required final int assignmentId,
    required final DateTime validFrom,
    required final DateTime? validUntil,
  }) async {
    final assignment = await AccessPolicyMember.db.findById(
      session,
      assignmentId,
    );
    if (assignment == null) {
      throw DoorDeviceException(
        message: 'Zuweisung wurde nicht gefunden.',
      );
    }
    _validateValidity(validFrom, validUntil);
    final updated = await AccessPolicyMember.db.updateRow(
      session,
      assignment.copyWith(validFrom: validFrom, validUntil: validUntil),
    );
    final profile = await MemberProfile.db.findById(
      session,
      updated.memberProfileId,
    );
    if (profile == null) {
      throw DoorDeviceException(message: 'Member wurde nicht gefunden.');
    }
    return _toMemberData(updated, profile);
  }

  /// Removes one assignment.
  Future<void> removeMemberAssignment(
    final Session session, {
    required final int assignmentId,
  }) async {
    final assignment = await AccessPolicyMember.db.findById(
      session,
      assignmentId,
    );
    if (assignment == null) {
      throw DoorDeviceException(
        message: 'Zuweisung wurde nicht gefunden.',
      );
    }
    await AccessPolicyMember.db.deleteRow(session, assignment);
  }

  /// The member's policy assignments (member-detail section): policy
  /// names + per-user periods.
  Future<List<MemberPolicyAssignmentData>> listPoliciesFor(
    final Session session, {
    required final UuidValue globalAuthUserId,
  }) async {
    final assignments = await AccessPolicyMember.db.find(
      session,
      where: (t) => t.globalAuthUserId.equals(globalAuthUserId),
      orderByList: (t) => [t.validFrom.desc()],
    );
    if (assignments.isEmpty) return [];
    final policyIds = assignments.map((a) => a.policyId).toSet();
    final policies = await AccessPolicy.db.find(
      session,
      where: (t) => t.id.inSet(policyIds),
    );
    final namesById = {for (final p in policies) p.id!: p.name};
    return [
      for (final assignment in assignments)
        MemberPolicyAssignmentData(
          assignmentId: assignment.id!,
          policyId: assignment.policyId,
          policyName: namesById[assignment.policyId] ?? '?',
          validFrom: assignment.validFrom,
          validUntil: assignment.validUntil,
        ),
    ];
  }

  // -- Private helpers

  Future<AccessPolicy> _requirePolicy(
    final Session session,
    final int id,
  ) async {
    final policy = await AccessPolicy.db.findById(session, id);
    if (policy == null) {
      throw DoorDeviceException(
        message: 'Berechtigung wurde nicht gefunden.',
      );
    }
    return policy;
  }

  Future<DoorDevice> _requireDevice(final Session session, final int id) async {
    final device = await DoorDevice.db.findById(session, id);
    if (device == null) {
      throw DoorDeviceException(message: 'Gerät wurde nicht gefunden.');
    }
    return device;
  }

  String _validateName(final String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw DoorDeviceException(message: 'Der Name darf nicht leer sein.');
    }
    return trimmed;
  }

  void _validateWindow(final int startMinute, final int endMinute) {
    if (startMinute < 0 ||
        startMinute > 1439 ||
        endMinute < 1 ||
        endMinute > 1440 ||
        endMinute <= startMinute) {
      throw DoorDeviceException(
        message:
            'Ungültiges Zeitfenster — Beginn 00:00-23:59, Ende 00:00(=24:00) '
            'nach dem Beginn.',
      );
    }
  }

  void _validateValidity(final DateTime from, final DateTime? until) {
    if (until != null && !until.isAfter(from)) {
      throw DoorDeviceException(
        message: 'Das Ende des Zeitraums muss nach dem Beginn liegen.',
      );
    }
  }

  DoorPolicyRuleData _toRuleData(
    final AccessPolicyRule rule, {
    final String? deviceName,
  }) {
    return DoorPolicyRuleData(
      id: rule.id!,
      deviceId: rule.deviceId,
      deviceName: deviceName,
      weekday: rule.weekday,
      startMinute: rule.startMinute,
      endMinute: rule.endMinute,
    );
  }

  DoorPolicyMemberData _toMemberData(
    final AccessPolicyMember assignment,
    final MemberProfile profile,
  ) {
    return DoorPolicyMemberData(
      id: assignment.id!,
      globalAuthUserId: assignment.globalAuthUserId,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      validFrom: assignment.validFrom,
      validUntil: assignment.validUntil,
    );
  }
}
