import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../auth/scopes.dart';
import '../generated/protocol.dart';
import '../images/image_url_signer.dart';
import 'site_device_authentication.dart';
import 'site_field_validation.dart';

/// Admin endpoint for creating and viewing sites ("Betriebe").
///
/// Access is enforced declaratively via [requiredScopes] (`global-admin`).
///
/// Enrollment with the global credentials happens in
/// [SiteEnrollmentEndpoint]; the persistent device connection uses
/// [SiteConnectionEndpoint].
class SitesAdminEndpoint extends Endpoint {
  /// Maximum sites per page (the client asks about 50; the server clamps).
  static const int pageSize = 50;

  @override
  Set<Scope> get requiredScopes => {const Scope(kGlobalAdminScope)};

  /// Creates a site and seeds the `siteAdmin` membership for the chosen
  /// first admin. Enrollment (linking the local instance) happens in a
  /// separate step — the admin enters their global credentials at the local
  /// setup mask, no secrets are generated here.
  Future<Site> createSite(
    final Session session, {
    required final String name,
    required final String street,
    required final String zipCode,
    required final String city,
    required final String country,
    required final String companyEmail,
    required final UuidValue firstAdminId,
  }) async {
    final nameValue = SiteFieldValidation.requireField(name, 'name');
    final streetValue = SiteFieldValidation.requireField(street, 'street');
    final zipCodeValue = SiteFieldValidation.requireField(zipCode, 'zipCode');
    final cityValue = SiteFieldValidation.requireField(city, 'city');
    final countryValue = SiteFieldValidation.requireField(country, 'country');
    final emailValue = SiteFieldValidation.requireValidEmail(companyEmail);

    final firstAdmin = await AuthServices.instance.authUsers.get(
      session,
      authUserId: firstAdminId,
    );
    if (firstAdmin.blocked) {
      throw SiteAdminException(
        message: 'Der gewählte Admin-Nutzer ist gesperrt.',
      );
    }

    // The membership links the person via member_profile — the sparse
    // profile row is created at registration (hook); if it is missing
    // despite that, fail loudly instead of creating a half-linked state.
    final adminProfile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(firstAdminId),
    );
    if (adminProfile == null) {
      throw SiteAdminException(
        message: 'Für den gewählten Admin-Nutzer fehlt das member_profile.',
      );
    }

    final site = await Site.db.insertRow(
      session,
      Site(
        name: nameValue,
        street: streetValue,
        zipCode: zipCodeValue,
        city: cityValue,
        country: countryValue,
        companyEmail: emailValue,
        firstAdminId: firstAdminId,
      ),
    );

    await SiteMembership.db.insertRow(
      session,
      SiteMembership(
        siteId: site.id!,
        profileId: adminProfile.id!,
        role: SiteRole.siteAdmin,
      ),
    );

    return site;
  }

  /// Lists sites, newest first, paginated. [query] filters by name,
  /// company email or city (case-insensitive substring).
  Future<List<Site>> listSites(
    final Session session, {
    final String? query,
    final int offset = 0,
    final int limit = pageSize,
  }) async {
    final q = query?.trim() ?? '';
    final filter = q.isEmpty
        ? null
        : (t) =>
              Site.t.name.ilike('%${_escapeLike(q)}%') |
              Site.t.companyEmail.ilike('%${_escapeLike(q)}%') |
              Site.t.city.ilike('%${_escapeLike(q)}%');

    return Site.db
        .find(
          session,
          where: filter,
          limit: limit.clamp(1, pageSize),
          offset: offset < 0 ? 0 : offset,
          orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
        )
        .then((rows) async {
          final signed = <Site>[];
          for (final row in rows) {
            signed.add(await _signSite(session, row));
          }
          return signed;
        });
  }

  /// Number of sites matching the given [query] (for the "more available"
  /// hint in the UI).
  Future<int> countSites(final Session session, {final String? query}) async {
    final q = query?.trim() ?? '';
    final filter = q.isEmpty
        ? null
        : (t) =>
              Site.t.name.ilike('%${_escapeLike(q)}%') |
              Site.t.companyEmail.ilike('%${_escapeLike(q)}%') |
              Site.t.city.ilike('%${_escapeLike(q)}%');

    return Site.db.count(
      session,
      where: filter,
    );
  }

  /// Returns a single site (detail route/deep links in the UI).
  Future<Site> getSite(
    final Session session, {
    required final int siteId,
  }) async {
    final site = await Site.db.findById(session, siteId);
    if (site == null) {
      throw SiteAdminException(message: 'Site wurde nicht gefunden.');
    }
    return _signSite(session, site);
  }

  /// Ends the device credential for the local instance (e.g. to force a
  /// new enrollment: the next local setup must re-verify global
  /// credentials). Site data/memberships are kept.
  Future<Site> revokeSiteConnection(
    final Session session, {
    required final int siteId,
  }) async {
    // Internal use only: must NOT get a signed URL (signing is exclusive
    // to terminal payload assembly — a signed URL is not a valid object
    // path and would be lost on re-signing).
    final site = await Site.db.findById(session, siteId);
    if (site == null) {
      throw SiteAdminException(message: 'Site wurde nicht gefunden.');
    }
    final deviceSessions = await SiteDeviceSession.db.find(
      session,
      where: (t) => t.siteId.equals(siteId),
    );
    for (final row in deviceSessions) {
      await SiteDeviceAuthentication.sessions.revokeSession(
        session,
        serverSideSessionId: row.serverSideSessionId,
      );
      await SiteDeviceSession.db.deleteRow(session, row);
    }
    return _signSite(session, site);
  }

  Future<Site> _signSite(final Session session, final Site row) {
    return ImageUrlSigner.signed(session, row.imageUrl).then(
      (signedUrl) =>
          signedUrl == null ? row : row.copyWith(imageUrl: signedUrl),
    );
  }

  // -- Private helpers

  String _escapeLike(final String value) {
    return value
        .replaceAll('\\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }
}
