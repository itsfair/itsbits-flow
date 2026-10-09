import 'package:global_client/global_client.dart';

/// Display name of an admin user entry (composed from the member_profile
/// names; falls back to the email when the profile is not completed yet).
String adminUserDisplayName(final AdminUserSummary user) {
  final name = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
  return name.isEmpty ? user.email : name;
}
