import 'package:flutter/material.dart';

import '../site_directory.dart';

/// Site image with placeholder fallback (businessifies the cards and the
/// detail screens; the real upload feature arrives later).
class SiteImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;

  const SiteImage({required this.imageUrl, this.fit = BoxFit.cover, super.key});

  @override
  Widget build(final BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return const _SiteImagePlaceholder();
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          const _SiteImagePlaceholder(),
    );
  }
}

class _SiteImagePlaceholder extends StatelessWidget {
  const _SiteImagePlaceholder();

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.storefront_outlined,
        size: 40,
        color: theme.colorScheme.outline,
      ),
    );
  }
}

/// Compact site card for lists and carousels: image header, name, address
/// line and the connectivity chip (heartbeat-derived `isOnline`).
class SiteCard extends StatelessWidget {
  final SiteData site;

  /// Null = not clickable (a pure display card).
  final VoidCallback? onTap;

  const SiteCard({required this.site, this.onTap, super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 110,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SiteImage(imageUrl: site.imageUrl),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _SiteOnlineChip(
                      isOnline: site.isOnline,
                      statusLabel: site.statusLabel,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    site.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${site.zipCode} ${site.city}',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Connectivity chip derived from the server-computed heartbeat freshness
/// (same heuristic as the admin app: 90 s window). `statusLabel` overrides
/// both online/offline states (e.g. pending setup in the admin app).
class _SiteOnlineChip extends StatelessWidget {
  final bool isOnline;
  final String? statusLabel;

  const _SiteOnlineChip({required this.isOnline, this.statusLabel});

  @override
  Widget build(final BuildContext context) {
    final label = statusLabel;
    return Chip(
      avatar: Icon(
        statusLabel != null
            ? Icons.pending_outlined
            : isOnline
            ? Icons.wifi
            : Icons.wifi_off,
        size: 16,
        color: statusLabel != null
            ? Colors.blueGrey
            : isOnline
            ? Colors.green
            : Colors.red,
      ),
      label: Text(label ?? (isOnline ? 'Verbunden' : 'Offline')),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(220),
    );
  }
}
