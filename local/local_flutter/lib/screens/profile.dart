import 'package:flutter/material.dart';
import 'package:itsbits_shared/screens/profile_screen.dart' as shared;

import '../client.dart';

/// View-only profile page: the mirrored person data of the locally signed-in
/// person, rendered with the shared profile screen in READ-ONLY mode
/// (profiles are edited globally only — sync rule). The id field carries the
/// exchange/door key (globalAuthUserId, shared QR section).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return shared.ProfileScreen(
      api: memberProfileApi,
      profileState: profileState,
      editingEnabled: false,
    );
  }
}
