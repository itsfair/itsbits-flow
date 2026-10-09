import 'package:flutter/material.dart';

import '../site_directory.dart';
import '../widgets/site_card.dart';

/// Number of sites loaded per page (the server clamps to its page size).
const int kSiteListPageSize = 50;

/// Full list view of all sites with debounced search + "load more"
/// pagination, feeding the shared [SiteCard]. Used verbatim by the
/// end-user app; the global admin app reuses it for its own sites list
/// (the admin create-FAB stays host-side).
class SiteListScreen extends StatefulWidget {
  final SiteDirectoryApi api;

  /// Host navigation (route to the detail screen).
  final void Function(BuildContext context, SiteData site) onOpenSite;

  final String title;

  /// Per-site reload after return (e.g. after subscribing in the detail
  /// screen) — re-fetches the first page.
  final void Function(BuildContext context, SiteData site)? onOpenDetail;

  /// Host-provided FAB (admin flows); rendered on the shared Scaffold.
  final Widget? floatingActionButton;

  const SiteListScreen({
    required this.api,
    required this.onOpenSite,
    this.title = 'Sites',
    this.onOpenDetail,
    this.floatingActionButton,
    super.key,
  });

  @override
  State<SiteListScreen> createState() => _SiteListScreenState();
}

class _SiteListScreenState extends State<SiteListScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<SiteData> _items = [];
  int _total = 0;
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _loading = true;
      _error = null;
      _items = [];
    });
    try {
      final items = await widget.api.list(
        query: _query,
        offset: 0,
        limit: kSiteListPageSize,
      );
      final total = await widget.api.count(query: _query);
      if (!mounted) return;
      setState(() {
        _items = items;
        _total = total;
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final items = await widget.api.list(
        query: _query,
        offset: _items.length,
        limit: kSiteListPageSize,
      );
      if (!mounted) return;
      setState(() => _items.addAll(items));
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Laden fehlgeschlagen: $e')));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _onSearchChanged(String value) {
    final text = value.trim();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && text == _searchController.text.trim() && text != _query) {
        _query = text;
        _loadFirstPage();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final hasMore = _items.length < _total;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: widget.floatingActionButton,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Suche nach Name, E-Mail oder Stadt',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                IconButton(
                  tooltip: 'Neu laden',
                  onPressed: _loading ? null : _loadFirstPage,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Laden fehlgeschlagen: $_error',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            )
          else if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else ...[
            if (hasMore)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'Es gibt $_total Sites, ${_items.length} geladen — '
                  'weitere laden oder Suche verfeinern.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Keine Sites gefunden.'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 260,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final site = _items[index];
                        return SiteCard(
                          site: site,
                          onTap: () => widget.onOpenSite(context, site),
                        );
                      },
                    ),
            ),
            if (hasMore)
              Center(
                child: _loadingMore
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: OutlinedButton(
                          onPressed: _loadMore,
                          child: Text('Weitere $kSiteListPageSize laden'),
                        ),
                      ),
              ),
          ],
        ],
      ),
    );
  }
}
