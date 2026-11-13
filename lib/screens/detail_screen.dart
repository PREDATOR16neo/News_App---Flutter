import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';
import '../providers/bookmark_provider.dart';
import '../theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final isBookmarked = bookmarkProvider.isBookmarked(article);

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
          OutlinedButton.icon(
            onPressed: () {
              context.read<BookmarkProvider>().toggleBookmark(article);
            },
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            label: Text(
              isBookmarked ? 'Hapus dari favorit' : 'Tambahkan ke favorit',
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          FilledButton(
            onPressed: () async {
              final url = article.url;
              if (url != null && url.isNotEmpty) {
                // Tunggu proses pembukaan tautan selesai.
                await bukaArtikel(context, url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tautan artikel tidak tersedia.'),
                  ),
                );
              }
            },
            child: const Text('Baca selengkapnya'),
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

Future<void> bukaArtikel(BuildContext context, String url) async {
  final berhasil = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  if (!berhasil && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tidak bisa membuka tautan artikel.')),
    );
  }
}
