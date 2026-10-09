import 'dart:typed_data';

import 'package:global_client/global_client.dart';
import 'package:itsbits_shared/profile_state.dart';

/// Maps the global instance's generated `memberProfile` endpoints onto the
/// shared package's client-agnostic interface (the contract shape is
/// identical on every instance).
class GlobalMemberProfileApi implements MemberProfileApi {
  final EndpointMemberProfile _endpoints;

  GlobalMemberProfileApi(this._endpoints);

  MemberProfileData _toData(final MemberProfile profile) => MemberProfileData(
    authUserId: profile.authUserId.uuid,
    email: profile.email,
    firstName: profile.firstName,
    lastName: profile.lastName,
    birthday: profile.birthday,
    imageUrl: profile.imageUrl,
  );

  @override
  Future<MemberProfileData> get() async => _toData(await _endpoints.get());

  @override
  Future<MemberProfileData> save({
    required final String firstName,
    required final String lastName,
    required final DateTime birthday,
  }) async => _toData(
    await _endpoints.save(
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
    ),
  );

  @override
  Future<MemberProfileData> setUserImage({
    required final ByteData image,
  }) async => _toData(await _endpoints.setUserImage(image: image));

  @override
  Future<MemberProfileData> removeUserImage() async =>
      _toData(await _endpoints.removeUserImage());
}
