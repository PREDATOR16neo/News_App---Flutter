import 'package:material_ui/material_ui.dart';

import '../models/article.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail berita')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        children: [
          _buildArticleImage(context),
          const SizedBox(height: AppSpacing.medium),
          Text(article.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.small),
          Text(
            article.author ?? 'Penulis tidak tersedia',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Sumber: ${article.sourceName ?? 'Sumber tidak tersedia'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Tanggal terbit: ${article.publishedAt ?? 'Tanggal tidak tersedia'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            article.description ?? 'Deskripsi tidak tersedia',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.large),
          const FilledButton(onPressed: null, child: Text('Baca selengkapnya')),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Tautan akan tersedia pada tahap integrasi API.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage(BuildContext context) {
    final imageUrl = article.urlToImage;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: imageUrl == null || imageUrl.trim().isEmpty
          ? _buildImagePlaceholder(context)
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return _buildImagePlaceholder(context);
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder(context);
              },
            ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          semanticLabel: 'Gambar tidak tersedia',
        ),
      ),
    );
  }
}
