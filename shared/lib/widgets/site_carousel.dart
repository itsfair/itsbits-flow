import 'package:flutter/material.dart';

import '../site_directory.dart';
import 'site_card.dart';

/// Home-screen section: the newest sites side-scrolled as cards (typically
/// five; a cap of ten is enforced by the backend). The section title and
/// the "all sites" entry stay with the host app.
class SiteCardCarousel extends StatelessWidget {
  final List<SiteData> sites;

  final void Function(SiteData site) onOpenSite;

  const SiteCardCarousel({
    required this.sites,
    required this.onOpenSite,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    if (sites.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Noch keine Sites vorhanden.')),
      );
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final site = sites[index];
          return SizedBox(
            width: 240,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SiteCard(site: site, onTap: () => onOpenSite(site)),
            ),
          );
        },
      ),
    );
  }
}
