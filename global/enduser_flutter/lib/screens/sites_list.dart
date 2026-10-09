import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/screens/site_list_screen.dart';

import '../client.dart';

/// All sites (registered only, server-side filter) with search/pagination
/// — the shared list component with end-user navigation wired in.
class SitesListScreen extends StatelessWidget {
  const SitesListScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return SiteListScreen(
      api: siteDirectoryApi,
      title: 'Sites',
      onOpenSite: (context, site) => context.go('/site/${site.id}'),
    );
  }
}
