import 'package:flutter/material.dart';

import '../site_directory.dart';
import '../widgets/site_card.dart';

/// Display body of a site detail view shared by the end-user app and (with
/// its own action bar) the admin apps: image, name, connectivity chip,
/// address block and public contact. Host apps wrap it with their own
/// Scaffold/FAB/actions.
class SiteDetailBody extends StatelessWidget {
  final SiteData site;

  /// Works inside a scrollable (Constraints unbounded); the host decides
  /// whether it sits in a ListView.
  const SiteDetailBody({required this.site, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SiteImage(imageUrl: site.imageUrl),
              Positioned(
                top: 8,
                right: 8,
                child: Chip(
                  avatar: Icon(
                    site.isOnline ? Icons.wifi : Icons.wifi_off,
                    size: 18,
                    color: site.isOnline ? Colors.green : Colors.red,
                  ),
                  label: Text(site.isOnline ? 'Verbunden' : 'Offline'),
                  backgroundColor: theme.colorScheme.surface.withAlpha(220),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(site.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(
                '${site.street}\n'
                '${site.zipCode} ${site.city}\n'
                '${site.country}',
              ),
              const SizedBox(height: 8),
              Text('Kontakt: ${site.companyEmail}'),
            ],
          ),
        ),
      ],
    );
  }
}
