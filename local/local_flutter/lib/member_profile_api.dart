import 'dart:typed_data';

import 'package:itsbits_shared/profile_state.dart';
import 'package:local_client/local_client.dart' as lc;

/// Adapter mapping the generated local-client `memberProfile` endpoint
/// onto the shared `MemberProfileApi` contract. Display is READ-ONLY
/// (profiles are edited globally only — sync rule): `get` is implemented;
/// the write methods exist only to satisfy the interface and are never
/// called in this configuration.
class LocalMemberProfileApi implements MemberProfileApi {
  final lc.Client _client;

  LocalMemberProfileApi(this._client);

  @override
  Future<MemberProfileData> get() async {
    final profile = await _client.memberProfile.get();
    // The id field here is the exchange/door id (globalAuthUserId) —
    // the shared screen renders it as text + QR (door key).
    return MemberProfileData(
      authUserId: profile.globalAuthUserId.uuid,
      email: profile.email,
      firstName: profile.firstName,
      lastName: profile.lastName,
      birthday: profile.birthday,
      imageUrl: profile.imageUrl,
    );
  }

  @override
  Future<MemberProfileData> save({
    required final String firstName,
    required final String lastName,
    required final DateTime birthday,
  }) => Future.error(UnimplementedError('profiles are edited globally only'));

  @override
  Future<MemberProfileData> setUserImage({required final ByteData image}) =>
      Future.error(UnimplementedError('profiles are edited globally only'));

  @override
  Future<MemberProfileData> removeUserImage() =>
      Future.error(UnimplementedError('profiles are edited globally only'));
}
