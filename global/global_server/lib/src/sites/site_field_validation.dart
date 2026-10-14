import '../generated/protocol.dart';

/// Shared field validation for site data ("create" and "update" use the
/// identical rules — currently via [sites_admin_endpoint] and the
/// device-scoped `siteDetails.push`).
abstract final class SiteFieldValidation {
  static String requireField(final String value, final String field) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw SiteAdminException(message: '$field ist erforderlich.');
    }
    return trimmed;
  }

  static String requireValidEmail(final String email) {
    final value = requireField(email, 'companyEmail').toLowerCase();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      throw SiteAdminException(message: 'companyEmail ist nicht gültig.');
    }
    return value;
  }

  /// Applies the trim/validate rules to a full site field set.
  static ({
    String name,
    String street,
    String zipCode,
    String city,
    String country,
    String companyEmail,
  })
  requireAll({
    required final String name,
    required final String street,
    required final String zipCode,
    required final String city,
    required final String country,
    required final String companyEmail,
  }) {
    return (
      name: requireField(name, 'name'),
      street: requireField(street, 'street'),
      zipCode: requireField(zipCode, 'zipCode'),
      city: requireField(city, 'city'),
      country: requireField(country, 'country'),
      companyEmail: requireValidEmail(companyEmail),
    );
  }
}
