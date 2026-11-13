import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import 'detail_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return RefreshIndicator(
      onRefresh: provider.loadArticles,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.medium),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.articles.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.small),
        itemBuilder: (context, index) {
          final article = provider.articles[index];
          final sourceName = article.sourceName ?? 'Sumber tidak diketahui';
          final publishedAt =
              article.publishedAt ?? 'Waktu terbit tidak tersedia';

          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => DetailScreen(article: article),
                  ),
                );
              },
              title: Text(
                article.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '$sourceName · $publishedAt',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
