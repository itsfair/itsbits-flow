import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itsbits_shared/site_directory.dart';
import 'package:itsbits_shared/widgets/site_carousel.dart';

import '../client.dart';

/// Home page: a horizontally scrollable section with the newest sites +
/// the entry to the full site list. Image placeholder cards render until
/// the site-image feature exists.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _latestCount = 5;

  List<SiteData> _latest = [];
  bool _loading = true;
  bool _hadError = false;

  @override
  void initState() {
    super.initState();
    _loadLatest();
  }

  @override
  void didUpdateWidget(covariant final HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _loadLatest() async {
    setState(() {
      _loading = true;
      _hadError = false;
    });
    try {
      final sites = await siteDirectoryApi.listLatest(limit: _latestCount);
      if (!mounted) return;
      setState(() => _latest = sites);
    } on Exception {
      if (!mounted) return;
      setState(() => _hadError = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _loadLatest,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Neueste Sites',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.list),
                  label: const Text('Alle'),
                  onPressed: () => context.push('/sites'),
                ),
              ],
            ),
          ),
          if (_loading)
            const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_hadError)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Laden der Sites fehlgeschlagen.'),
                  TextButton(
                    onPressed: _loadLatest,
                    child: const Text('Erneut versuchen'),
                  ),
                ],
              ),
            )
          else
            SiteCardCarousel(
              sites: _latest,
              onOpenSite: (site) => context.push('/site/${site.id}'),
            ),
        ],
      ),
    );
  }
}
