import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berita favorit')),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final articles = bookmarkProvider.bookmarkedArticles;
          if (articles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Text(
                  'Belum ada berita favorit.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.medium),
            itemCount: articles.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.small),
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(
                article: article,
                isBookmarked: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => DetailScreen(article: article),
                    ),
                  );
                },
                onBookmarkToggle: () {
                  bookmarkProvider.toggleBookmark(article);
                },
              );
            },
          );
        },
      ),
    );
  }
}
