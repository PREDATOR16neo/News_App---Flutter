import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark_provider.dart';
import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _categories = ['Semua', 'Teknologi', 'Bisnis', 'Olahraga'];

  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    unawaited(context.read<NewsProvider>().loadArticles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berita terbaru')),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case NewsStatus.loading:
              return _buildLoadingView(context);
            case NewsStatus.success:
              return _buildArticleList(provider);
            case NewsStatus.error:
              return _buildErrorView(context, provider);
            case NewsStatus.empty:
              return _buildEmptyView(context, provider);
          }
        },
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'Memuat berita...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, NewsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Berita gagal dimuat. Periksa kembali dan coba lagi.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.medium),
            FilledButton(
              onPressed: provider.loadArticles,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context, NewsProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Belum ada berita untuk ditampilkan.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.medium),
            FilledButton(
              onPressed: provider.loadArticles,
              child: const Text('Muat ulang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(NewsProvider provider) {
    final query = _searchQuery.trim().toLowerCase();
    final articles = provider.articles.where((article) {
      final matchesCategory =
          _selectedCategory == 'Semua' ||
          article.category?.toLowerCase() == _selectedCategory.toLowerCase();
      final searchableText = [
        article.title,
        article.description ?? '',
        article.sourceName ?? '',
        article.author ?? '',
      ].join(' ').toLowerCase();
      return matchesCategory && searchableText.contains(query);
    }).toList();

    return RefreshIndicator(
      onRefresh: provider.loadArticles,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Cari berita',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() {
              _searchQuery = value;
            }),
          ),
          const SizedBox(height: AppSpacing.medium),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.small),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) => setState(() {
                      _selectedCategory = category;
                    }),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          if (articles.isEmpty)
            _buildNoMatchingArticlesView(context)
          else
            ...articles.map((article) {
              final isBookmarked = context
                  .watch<BookmarkProvider>()
                  .isBookmarked(article);

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.small),
                child: ArticleCard(
                  article: article,
                  isBookmarked: isBookmarked,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => DetailScreen(article: article),
                      ),
                    );
                  },
                  onBookmarkToggle: () {
                    context.read<BookmarkProvider>().toggleBookmark(article);
                  },
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildNoMatchingArticlesView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.large),
      child: Column(
        children: [
          Text(
            'Berita tidak ditemukan. Coba kata kunci atau kategori lain.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.medium),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
                _selectedCategory = 'Semua';
              });
            },
            child: const Text('Hapus filter'),
          ),
        ],
      ),
    );
  }
}
