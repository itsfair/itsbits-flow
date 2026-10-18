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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../door/door_device_admin_endpoint.dart' as _ij1q5man;
import '../site/member_profile_endpoint.dart' as _i0gpa131;
import '../site/members_admin_endpoint.dart' as _i37hx4yi;
import '../site/site_admin_endpoint.dart' as _it93jbo5;
import '../site/site_setup_endpoint.dart' as _iq6hjzpz;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'doorDeviceAdmin': _ij1q5man.DoorDeviceAdminEndpoint()
        ..initialize(
          server,
          'doorDeviceAdmin',
          null,
        ),
      'memberProfile': _i0gpa131.MemberProfileEndpoint()
        ..initialize(
          server,
          'memberProfile',
          null,
        ),
      'membersAdmin': _i37hx4yi.MembersAdminEndpoint()
        ..initialize(
          server,
          'membersAdmin',
          null,
        ),
      'siteAdmin': _it93jbo5.SiteAdminEndpoint()
        ..initialize(
          server,
          'siteAdmin',
          null,
        ),
      'siteSetup': _iq6hjzpz.SiteSetupEndpoint()
        ..initialize(
          server,
          'siteSetup',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['doorDeviceAdmin'] = _is.EndpointConnector(
      name: 'doorDeviceAdmin',
      endpoint: endpoints['doorDeviceAdmin']!,
      methodConnectors: {
        'listDevices': _is.MethodConnector(
          name: 'listDevices',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .listDevices(session),
        ),
        'addDevice': _is.MethodConnector(
          name: 'addDevice',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'address': _is.ParameterDescription(
              name: 'address',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .addDevice(
                        session,
                        name: params['name'],
                        address: params['address'],
                      ),
        ),
        'updateDevice': _is.MethodConnector(
          name: 'updateDevice',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'address': _is.ParameterDescription(
              name: 'address',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .updateDevice(
                        session,
                        id: params['id'],
                        name: params['name'],
                        address: params['address'],
                      ),
        ),
        'removeDevice': _is.MethodConnector(
          name: 'removeDevice',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .removeDevice(
                        session,
                        id: params['id'],
                      ),
        ),
        'testDevice': _is.MethodConnector(
          name: 'testDevice',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .testDevice(
                        session,
                        id: params['id'],
                      ),
        ),
        'unlockNuki': _is.MethodConnector(
          name: 'unlockNuki',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .unlockNuki(
                        session,
                        id: params['id'],
                      ),
        ),
        'lockNuki': _is.MethodConnector(
          name: 'lockNuki',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .lockNuki(
                        session,
                        id: params['id'],
                      ),
        ),
        'openNuki': _is.MethodConnector(
          name: 'openNuki',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .openNuki(
                        session,
                        id: params['id'],
                      ),
        ),
        'pushConfig': _is.MethodConnector(
          name: 'pushConfig',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['doorDeviceAdmin']
                          as _ij1q5man.DoorDeviceAdminEndpoint)
                      .pushConfig(
                        session,
                        id: params['id'],
                      ),
        ),
      },
    );
    connectors['memberProfile'] = _is.EndpointConnector(
      name: 'memberProfile',
      endpoint: endpoints['memberProfile']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['memberProfile']
                          as _i0gpa131.MemberProfileEndpoint)
                      .get(session),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'firstName': _is.ParameterDescription(
              name: 'firstName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'lastName': _is.ParameterDescription(
              name: 'lastName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'birthday': _is.ParameterDescription(
              name: 'birthday',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['memberProfile']
                          as _i0gpa131.MemberProfileEndpoint)
                      .save(
                        session,
                        firstName: params['firstName'],
                        lastName: params['lastName'],
                        birthday: params['birthday'],
                      ),
        ),
        'setUserImage': _is.MethodConnector(
          name: 'setUserImage',
          params: {
            'image': _is.ParameterDescription(
              name: 'image',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['memberProfile']
                          as _i0gpa131.MemberProfileEndpoint)
                      .setUserImage(
                        session,
                        image: params['image'],
                      ),
        ),
        'removeUserImage': _is.MethodConnector(
          name: 'removeUserImage',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['memberProfile']
                          as _i0gpa131.MemberProfileEndpoint)
                      .removeUserImage(session),
        ),
      },
    );
    connectors['membersAdmin'] = _is.EndpointConnector(
      name: 'membersAdmin',
      endpoint: endpoints['membersAdmin']!,
      methodConnectors: {
        'listMembers': _is.MethodConnector(
          name: 'listMembers',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['membersAdmin'] as _i37hx4yi.MembersAdminEndpoint)
                      .listMembers(
                        session,
                        query: params['query'],
                        offset: params['offset'],
                        limit: params['limit'],
                      ),
        ),
        'countMembers': _is.MethodConnector(
          name: 'countMembers',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['membersAdmin'] as _i37hx4yi.MembersAdminEndpoint)
                      .countMembers(
                        session,
                        query: params['query'],
                      ),
        ),
        'getMember': _is.MethodConnector(
          name: 'getMember',
          params: {
            'globalAuthUserId': _is.ParameterDescription(
              name: 'globalAuthUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['membersAdmin'] as _i37hx4yi.MembersAdminEndpoint)
                      .getMember(
                        session,
                        globalAuthUserId: params['globalAuthUserId'],
                      ),
        ),
      },
    );
    connectors['siteAdmin'] = _is.EndpointConnector(
      name: 'siteAdmin',
      endpoint: endpoints['siteAdmin']!,
      methodConnectors: {
        'updateSite': _is.MethodConnector(
          name: 'updateSite',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'street': _is.ParameterDescription(
              name: 'street',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'zipCode': _is.ParameterDescription(
              name: 'zipCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'city': _is.ParameterDescription(
              name: 'city',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'country': _is.ParameterDescription(
              name: 'country',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'companyEmail': _is.ParameterDescription(
              name: 'companyEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['siteAdmin'] as _it93jbo5.SiteAdminEndpoint)
                  .updateSite(
                    session,
                    name: params['name'],
                    street: params['street'],
                    zipCode: params['zipCode'],
                    city: params['city'],
                    country: params['country'],
                    companyEmail: params['companyEmail'],
                  ),
        ),
        'setSiteImage': _is.MethodConnector(
          name: 'setSiteImage',
          params: {
            'image': _is.ParameterDescription(
              name: 'image',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['siteAdmin'] as _it93jbo5.SiteAdminEndpoint)
                  .setSiteImage(
                    session,
                    image: params['image'],
                  ),
        ),
        'removeSiteImage': _is.MethodConnector(
          name: 'removeSiteImage',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['siteAdmin'] as _it93jbo5.SiteAdminEndpoint)
                  .removeSiteImage(session),
        ),
      },
    );
    connectors['siteSetup'] = _is.EndpointConnector(
      name: 'siteSetup',
      endpoint: endpoints['siteSetup']!,
      methodConnectors: {
        'enterSetup': _is.MethodConnector(
          name: 'enterSetup',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'siteId': _is.ParameterDescription(
              name: 'siteId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['siteSetup'] as _iq6hjzpz.SiteSetupEndpoint)
                  .enterSetup(
                    session,
                    email: params['email'],
                    password: params['password'],
                    siteId: params['siteId'],
                  ),
        ),
        'connectionStatus': _is.MethodConnector(
          name: 'connectionStatus',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['siteSetup'] as _iq6hjzpz.SiteSetupEndpoint)
                  .connectionStatus(session),
        ),
        'adminInfo': _is.MethodConnector(
          name: 'adminInfo',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['siteSetup'] as _iq6hjzpz.SiteSetupEndpoint)
                  .adminInfo(session),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
