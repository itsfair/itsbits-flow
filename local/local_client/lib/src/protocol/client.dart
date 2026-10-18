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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:local_client/src/protocol/door/door_device.dart' as _izp9nmgv;
import 'package:local_client/src/protocol/door/door_device_push_result.dart'
    as _i4kgn637;
import 'package:local_client/src/protocol/door/door_device_status.dart'
    as _ite4y8tc;
import 'package:local_client/src/protocol/site/local_admin_info.dart'
    as _iwwog9lz;
import 'package:local_client/src/protocol/site/member_detail.dart' as _ietksnoz;
import 'package:local_client/src/protocol/site/member_profile.dart'
    as _iakvgpur;
import 'package:local_client/src/protocol/site/member_summary.dart'
    as _i5ndcnpn;
import 'package:local_client/src/protocol/site/site_connection.dart'
    as _ijbx0283;
import 'package:local_client/src/protocol/site/site_connection_info.dart'
    as _i0a8fvnn;
import 'package:local_client/src/protocol/site/site_setup_result.dart'
    as _iyg9qq9q;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in
/// widget on the client. Member self-signup is intentionally not offered in
/// any UI; logins are only ever created from *verified* global logins (see
/// AGENTS.md).
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Admin endpoint for the site's doorinterface devices (ESP32) — the LAN
/// registry of `Selbsteinlass`: add devices by address (IP or local
/// hostname), test the connection via the ESP's `/api/status`, and
/// trigger the NUKI lock/unlock/open actions. The HTTP calls to the ESP
/// happen on the SERVER side (LAN authority stays with the instance,
/// avoids browser CORS).
///
/// MVP security stance: plain HTTP into the local network (the ESP's web
/// interface as unauthenticated as its dashboard); device
/// authentication/TLS is a known security backlog item. The NUKI unlock/
/// lock/open routes are fixed backend-side paths — no generic proxying.
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`
/// scope of the site admin's local login), same as membersAdmin/siteAdmin.
/// {@category Endpoint}
class EndpointDoorDeviceAdmin extends _isc.EndpointRef {
  EndpointDoorDeviceAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'doorDeviceAdmin';

  /// All registered devices, newest first.
  _ida.Future<List<_izp9nmgv.DoorDevice>> listDevices() =>
      caller.callServerEndpoint<List<_izp9nmgv.DoorDevice>>(
        'doorDeviceAdmin',
        'listDevices',
        {},
      );

  /// Registers a new device ("Gerät hinzufügen") and IMMEDIATELY pushes
  /// the backend config (serverUrl + siteId) to it — best effort: a
  /// failed push never blocks the registration (re-push via
  /// [pushConfig] later).
  _ida.Future<_izp9nmgv.DoorDevice> addDevice({
    required String name,
    required String address,
  }) => caller.callServerEndpoint<_izp9nmgv.DoorDevice>(
    'doorDeviceAdmin',
    'addDevice',
    {
      'name': name,
      'address': address,
    },
  );

  /// Updates the display name and/or the address.
  _ida.Future<_izp9nmgv.DoorDevice> updateDevice({
    required int id,
    String? name,
    String? address,
  }) => caller.callServerEndpoint<_izp9nmgv.DoorDevice>(
    'doorDeviceAdmin',
    'updateDevice',
    {
      'id': id,
      'name': name,
      'address': address,
    },
  );

  /// Removes the registry entry (the ESP itself is untouched).
  _ida.Future<void> removeDevice({required int id}) =>
      caller.callServerEndpoint<void>(
        'doorDeviceAdmin',
        'removeDevice',
        {'id': id},
      );

  /// Probes `GET http://<address>/api/status` and parses the ESP JSON
  /// losslessly (server-side call, timeout 5 s).
  _ida.Future<_ite4y8tc.DoorDeviceStatus> testDevice({required int id}) =>
      caller.callServerEndpoint<_ite4y8tc.DoorDeviceStatus>(
        'doorDeviceAdmin',
        'testDevice',
        {'id': id},
      );

  /// `POST /api/nuki/unlock` on the device (NUKI entriegeln).
  _ida.Future<_ite4y8tc.DoorDeviceStatus> unlockNuki({required int id}) =>
      caller.callServerEndpoint<_ite4y8tc.DoorDeviceStatus>(
        'doorDeviceAdmin',
        'unlockNuki',
        {'id': id},
      );

  /// `POST /api/nuki/lock` on the device (NUKI verriegeln).
  _ida.Future<_ite4y8tc.DoorDeviceStatus> lockNuki({required int id}) =>
      caller.callServerEndpoint<_ite4y8tc.DoorDeviceStatus>(
        'doorDeviceAdmin',
        'lockNuki',
        {'id': id},
      );

  /// `POST /api/nuki/open` on the device (NUKI entsichern / unlatch).
  _ida.Future<_ite4y8tc.DoorDeviceStatus> openNuki({required int id}) =>
      caller.callServerEndpoint<_ite4y8tc.DoorDeviceStatus>(
        'doorDeviceAdmin',
        'openNuki',
        {'id': id},
      );

  /// Pushes the backend config (server URL from the `localApiUrl`
  /// password key + this instance's site ID) to the device
  /// (`POST http://<address>/api/backend/config`). The device ACKs with
  /// its identity; the MAC is stored on the registry row and
  /// `configuredAt` marks a successful push.
  _ida.Future<_i4kgn637.DoorDevicePushResult> pushConfig({required int id}) =>
      caller.callServerEndpoint<_i4kgn637.DoorDevicePushResult>(
        'doorDeviceAdmin',
        'pushConfig',
        {'id': id},
      );
}

/// Own person/profile endpoints of the local instance — mirror of the
/// global `memberProfile` endpoint (same model shape, see AGENTS.md).
///
/// The `member_profile` table is the local person directory; rows exist
/// for every person of the site, and persons WITH a local login
/// (site admin / staff) carry the `authUserId` link. Profiles are edited
/// globally only (sync rule) — these endpoints exist for locally
/// logged-in persons to READ their mirrored data (and, if ever desired,
/// write — same conventions as global: deterministic image name,
/// JPEG-only, UTC-midnight birthday sentinels).
/// {@category Endpoint}
class EndpointMemberProfile extends _isc.EndpointRef {
  EndpointMemberProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'memberProfile';

  /// Returns the signed-in person's profile (lookup via the local login →
  /// `authUserId` link).
  ///
  /// Unlike the global endpoint there is NO self-heal fallback: the
  /// exchange key (`globalAuthUserId`) cannot be derived from a local
  /// login alone, and enrollment always creates the copy with the correct
  /// global id. A missing row here is a real error — fail loudly instead
  /// of writing a wrong exchange key.
  _ida.Future<_iakvgpur.MemberProfile> get() =>
      caller.callServerEndpoint<_iakvgpur.MemberProfile>(
        'memberProfile',
        'get',
        {},
      );

  /// Validates and saves the locally mirrored profile data of the
  /// signed-in person. NOTE: profiles are meant to be edited globally
  /// only (sync rule) — local writes overwrite the mirror until the next
  /// sync brings global state back.
  _ida.Future<_iakvgpur.MemberProfile> save({
    required String firstName,
    required String lastName,
    required DateTime birthday,
  }) => caller.callServerEndpoint<_iakvgpur.MemberProfile>(
    'memberProfile',
    'save',
    {
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
    },
  );

  /// Stores the uploaded image at
  /// `member_images/<globalAuthUserId>.jpg` — the deterministic name
  /// shared with the global instance (same person id; parity by
  /// construction).
  _ida.Future<_iakvgpur.MemberProfile> setUserImage({
    required _idt.ByteData image,
  }) => caller.callServerEndpoint<_iakvgpur.MemberProfile>(
    'memberProfile',
    'setUserImage',
    {'image': image},
  );

  /// Deletes the locally stored object and clears `imageUrl` (NOTE: the
  /// global image remains its source of truth; the next sync restores
  /// the mirror).
  _ida.Future<_iakvgpur.MemberProfile> removeUserImage() =>
      caller.callServerEndpoint<_iakvgpur.MemberProfile>(
        'memberProfile',
        'removeUserImage',
        {},
      );
}

/// Admin endpoint for the local member directory (read-only this step):
/// lists/searches the site's member_profile mirror records and returns
/// one member in detail. Editing happens globally only (sync rule).
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`
/// scope of the site admin's local login).
/// {@category Endpoint}
class EndpointMembersAdmin extends _isc.EndpointRef {
  EndpointMembersAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'membersAdmin';

  /// Lists the site's members (newest profiles first), paginated; [query]
  /// filters by email, first name or last name (case-insensitive
  /// substring).
  _ida.Future<List<_i5ndcnpn.MemberSummary>> listMembers({
    String? query,
    required int offset,
    required int limit,
  }) => caller.callServerEndpoint<List<_i5ndcnpn.MemberSummary>>(
    'membersAdmin',
    'listMembers',
    {
      'query': query,
      'offset': offset,
      'limit': limit,
    },
  );

  /// Number of members matching [query] (pagination hint).
  _ida.Future<int> countMembers({String? query}) =>
      caller.callServerEndpoint<int>(
        'membersAdmin',
        'countMembers',
        {'query': query},
      );

  /// One member in detail; unknown exchange ids are rejected.
  _ida.Future<_ietksnoz.MemberDetail> getMember({
    required _isc.UuidValue globalAuthUserId,
  }) => caller.callServerEndpoint<_ietksnoz.MemberDetail>(
    'membersAdmin',
    'getMember',
    {'globalAuthUserId': globalAuthUserId},
  );
}

/// Local admin endpoint for editing THIS site's properties (name, address,
/// contact) and its image. Editing happens LOCALLY only (mirror rule
/// reversed versus member profiles) and — by design — requires the live
/// connection to the global instance: the update is pushed FIRST to the
/// global `siteDetails` endpoint (device credential, server-to-server) and
/// only on success applied to the local snapshot. No queuing/offline mode.
///
/// Access is enforced declaratively via [requiredScopes] (`local-admin`).
/// {@category Endpoint}
class EndpointSiteAdmin extends _isc.EndpointRef {
  EndpointSiteAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'siteAdmin';

  /// Updates the site properties (fail-closed: any push failure leaves the
  /// local snapshot untouched; validation happens on the global side —
  /// one source of truth for the field rules).
  _ida.Future<_ijbx0283.SiteConnection> updateSite({
    required String name,
    required String street,
    required String zipCode,
    required String city,
    required String country,
    required String companyEmail,
  }) => caller.callServerEndpoint<_ijbx0283.SiteConnection>(
    'siteAdmin',
    'updateSite',
    {
      'name': name,
      'street': street,
      'zipCode': zipCode,
      'city': city,
      'country': country,
      'companyEmail': companyEmail,
    },
  );

  /// Uploads/overwrites the site image (JPEG, like the profile image).
  /// The object is stored BOTH globally (end user + admin display) and
  /// locally (offline-capable local display), deterministic path.
  _ida.Future<_ijbx0283.SiteConnection> setSiteImage({
    required _idt.ByteData image,
  }) => caller.callServerEndpoint<_ijbx0283.SiteConnection>(
    'siteAdmin',
    'setSiteImage',
    {'image': image},
  );

  /// Removes the site image on BOTH sides (global first, then local).
  _ida.Future<_ijbx0283.SiteConnection> removeSiteImage() =>
      caller.callServerEndpoint<_ijbx0283.SiteConnection>(
        'siteAdmin',
        'removeSiteImage',
        {},
      );
}

/// Local setup endpoint: connects this instance to its site's global
/// instance by verifying with the **global credentials of the site admin**
/// (the one chosen at site creation). Fills the local member_profile copy
/// for the admin (identity: their global authUserId) and creates the local
/// `local-admin` login with the same password.
/// {@category Endpoint}
class EndpointSiteSetup extends _isc.EndpointRef {
  EndpointSiteSetup(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'siteSetup';

  /// Verifies the entered global credentials against the global backend,
  /// stores the enrollment and starts the connection worker.
  ///
  /// When the global user is site admin of several sites the first call
  /// returns `requiresSiteSelection` with the candidates; retry with the
  /// chosen [siteId].
  _ida.Future<_iyg9qq9q.SiteSetupResult> enterSetup({
    required String email,
    required String password,
    int? siteId,
  }) => caller.callServerEndpoint<_iyg9qq9q.SiteSetupResult>(
    'siteSetup',
    'enterSetup',
    {
      'email': email,
      'password': password,
      'siteId': siteId,
    },
  );

  /// The current local connection state (App-Bar chip in the admin UI).
  _ida.Future<_i0a8fvnn.SiteConnectionInfo> connectionStatus() =>
      caller.callServerEndpoint<_i0a8fvnn.SiteConnectionInfo>(
        'siteSetup',
        'connectionStatus',
        {},
      );

  /// Everything the local admin UI displays about this instance:
  /// connection state + site snapshot + the admin's mirrored person data
  /// (local `member_profile` copy, joined via the exchange id
  /// `site_connections.adminAuthUserId`). The default of the state
  /// is `noneSetup` with an empty snapshot until the instance is enrolled.
  _ida.Future<_iwwog9lz.LocalAdminInfo> adminInfo() =>
      caller.callServerEndpoint<_iwwog9lz.LocalAdminInfo>(
        'siteSetup',
        'adminInfo',
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    doorDeviceAdmin = EndpointDoorDeviceAdmin(this);
    memberProfile = EndpointMemberProfile(this);
    membersAdmin = EndpointMembersAdmin(this);
    siteAdmin = EndpointSiteAdmin(this);
    siteSetup = EndpointSiteSetup(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointDoorDeviceAdmin doorDeviceAdmin;

  late final EndpointMemberProfile memberProfile;

  late final EndpointMembersAdmin membersAdmin;

  late final EndpointSiteAdmin siteAdmin;

  late final EndpointSiteSetup siteSetup;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'doorDeviceAdmin': doorDeviceAdmin,
    'memberProfile': memberProfile,
    'membersAdmin': membersAdmin,
    'siteAdmin': siteAdmin,
    'siteSetup': siteSetup,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
