import '../generated/protocol.dart';

/// Reusable profile-completeness rule of the global instance: a profile is
/// "complete" when all mandatory person data is filled. Blocks e.g. site
/// subscriptions until the user finished their profile; reusable at other
/// checkpoints.
extension MemberProfileChecks on MemberProfile {
  bool get profileIsComplete =>
      email.isNotEmpty &&
      (firstName?.isNotEmpty ?? false) &&
      (lastName?.isNotEmpty ?? false) &&
      birthday != null;
}
