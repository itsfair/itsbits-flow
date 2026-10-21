import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../images/image_url_signer.dart';
import 'global_site_connection.dart';

/// Admin endpoint for the local member directory (read-only this step):
/// lists/searches the site's member_profile mirror records and returns
/// one member in detail. Editing happens globally only (sync rule).
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`
/// scope of the site admin's local login).
class MembersAdminEndpoint extends Endpoint {
  static const int pageSize = 50;

  @override
  Set<Scope> get requiredScopes => {const Scope(kLocalAdminScope)};

  /// Lists the site's members (newest profiles first), paginated; [query]
  /// filters by email, first name or last name (case-insensitive
  /// substring).
  Future<List<MemberSummary>> listMembers(
    final Session session, {
    final String? query,
    final int offset = 0,
    final int limit = pageSize,
  }) async {
    final q = query?.trim() ?? '';
    final filter = q.isEmpty
        ? null
        : (final MemberProfileTable t) =>
              t.email.ilike('%${_escapeLike(q)}%') |
              t.firstName.ilike('%${_escapeLike(q)}%') |
              t.lastName.ilike('%${_escapeLike(q)}%');

    final profiles = await MemberProfile.db.find(
      session,
      where: filter,
      limit: limit.clamp(1, pageSize),
      offset: offset < 0 ? 0 : offset,
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
    );

    final membershipByProfileId = await _membershipsByProfileId(session);

    return [
      for (final profile in profiles)
        await _toSummary(session, profile, membershipByProfileId[profile.id]),
    ];
  }

  /// Number of members matching [query] (pagination hint).
  Future<int> countMembers(final Session session, {final String? query}) async {
    final q = query?.trim() ?? '';
    final filter = q.isEmpty
        ? null
        : (final MemberProfileTable t) =>
              t.email.ilike('%${_escapeLike(q)}%') |
              t.firstName.ilike('%${_escapeLike(q)}%') |
              t.lastName.ilike('%${_escapeLike(q)}%');
    return MemberProfile.db.count(session, where: filter);
  }

  /// One member in detail; unknown exchange ids are rejected.
  Future<MemberDetail> getMember(
    final Session session, {
    required final UuidValue globalAuthUserId,
  }) async {
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.globalAuthUserId.equals(globalAuthUserId),
    );
    if (profile == null) {
      throw SiteSetupException(message: 'Member wurde nicht gefunden.');
    }

    final memberships = await MemberMembership.db.find(
      session,
      where: (t) => t.globalAuthUserId.equals(globalAuthUserId),
    );

    return MemberDetail(
      globalAuthUserId: profile.globalAuthUserId,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      birthday: profile.birthday,
      imageUrl: await ImageUrlSigner.signed(session, profile.imageUrl),
      profileCreatedAt: profile.createdAt,
      hasLocalLogin: profile.authUserId != null,
      roleName: memberships.firstOrNull?.role.name,
      active: memberships.firstOrNull?.active,
      endedAt: memberships.firstOrNull?.endedAt,
      membershipCreatedAt: memberships.firstOrNull?.createdAt,
    );
  }

  // -- Private helpers

  Future<Map<int, MemberMembership>> _membershipsByProfileId(
    final Session session,
  ) async {
    final memberships = await MemberMembership.db.find(session);
    return {
      for (final membership in memberships)
        membership.memberProfileId: membership,
    };
  }

  Future<MemberSummary> _toSummary(
    final Session session,
    final MemberProfile profile,
    final MemberMembership? membership,
  ) async {
    return MemberSummary(
      globalAuthUserId: profile.globalAuthUserId,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      imageUrl: await ImageUrlSigner.signed(session, profile.imageUrl),
      hasLocalLogin: profile.authUserId != null,
      roleName: membership?.role.name,
      active: membership?.active,
      endedAt: membership?.endedAt,
    );
  }

  String _escapeLike(final String value) {
    return value
        .replaceAll('\\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }
}
