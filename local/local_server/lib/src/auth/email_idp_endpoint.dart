import 'package:serverpod_auth_idp_server/providers/email.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in
/// widget on the client. Member self-signup is intentionally not offered in
/// any UI; logins are only ever created from *verified* global logins (see
/// AGENTS.md).
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {}
