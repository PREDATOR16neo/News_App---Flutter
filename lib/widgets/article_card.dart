import 'package:material_ui/material_ui.dart';

import '../models/article.dart';
import '../theme/app_theme.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  final Article article;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(context),
            ListTile(
              title: Text(
                article.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                '${article.sourceName ?? 'Sumber tidak diketahui'} · '
                '${article.publishedAt ?? 'Waktu terbit tidak tersedia'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: IconButton(
                tooltip: isBookmarked
                    ? 'Hapus dari favorit'
                    : 'Tambahkan ke favorit',
                onPressed: onBookmarkToggle,
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageUrl = article.urlToImage;

    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return _buildImagePlaceholder(context);
    }

    return Image.network(
      imageUrl,
      height: AppDimensions.articleImageHeight,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _buildImagePlaceholder(context),
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null ? child : _buildImagePlaceholder(context),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return SizedBox(
      height: AppDimensions.articleImageHeight,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            semanticLabel: 'Gambar tidak tersedia',
          ),
        ),
      ),
    );
  }
}
