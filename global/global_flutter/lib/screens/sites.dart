import 'package:flutter/material.dart';
import 'package:global_client/global_client.dart' as gc;
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/site_list_screen.dart';

import '../admin_site_directory_api.dart';
import 'create_site_dialog.dart';

/// Lists all sites ("Betriebe") via the shared list component (search +
/// pagination + shared site cards); the create flow is the admin-FAB and
/// the detail screen is admin-only. Connectivity display per site works
/// via the device heartbeats; live push is a To-do.
class SitesScreen extends StatelessWidget {
  const SitesScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return SiteListScreen(
      api: const AdminSiteDirectoryApi(),
      onOpenSite: (context, site) => context.go('/sites/${site.id}'),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'admin-sites-fab',
        icon: const Icon(Icons.add_business),
        label: const Text('Site anlegen'),
        onPressed: () => _openCreateDialog(context),
      ),
    );
  }
}

Future<void> _openCreateDialog(final BuildContext context) async {
  final created = await showDialog<gc.Site>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const CreateSiteDialog(),
  );
  if (created == null || !context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Site angelegt. Die Einrichtung erfolgt vor Ort: der Site-Admin '
        'gibt dort seine globalen Anmeldedaten ein (keine Secrets nötig).',
      ),
    ),
  );
  context.go('/sites/${created.id!}');
}
