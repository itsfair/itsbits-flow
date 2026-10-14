import 'package:flutter/material.dart';
import 'package:itsbits_shared/screens/site_details_editor.dart';

import '../client.dart';
import '../site_details_api.dart';

/// "Standort" page: site details editor (shared component) — site data is
/// edited LOCALLY (reversed mirror rule vs. member profiles) and pushed to
/// the global instance while connected; the image is stored on both sides.
class StandortScreen extends StatelessWidget {
  const StandortScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Standort')),
      body: SiteDetailsEditorScreen(
        api: LocalSiteDetailsApi(client),
        editingEnabled: true,
      ),
    );
  }
}
