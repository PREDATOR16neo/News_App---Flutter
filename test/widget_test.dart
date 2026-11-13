import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/mock_news_service.dart';
import 'package:news_app/services/news_service.dart';

void main() {
  testWidgets('menampilkan loading lalu daftar berita', (tester) async {
    await tester.pumpWidget(
      MyApp(newsService: MockNewsService(delay: const Duration(seconds: 1))),
    );

    expect(find.text('Memuat berita...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Berita terbaru'), findsOneWidget);
    expect(
      find.text('Inovasi teknologi lokal terus berkembang'),
      findsOneWidget,
    );
  });

  testWidgets('menampilkan pesan error dan tombol coba lagi', (tester) async {
    await tester.pumpWidget(
      MyApp(
        newsService: MockNewsService(
          responseMode: MockResponseMode.error,
          delay: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Berita gagal dimuat. Periksa kembali dan coba lagi.'),
      findsOneWidget,
    );
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('menampilkan hasil kosong dan tombol muat ulang', (tester) async {
    await tester.pumpWidget(
      MyApp(
        newsService: MockNewsService(
          responseMode: MockResponseMode.empty,
          delay: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada berita untuk ditampilkan.'), findsOneWidget);
    expect(find.text('Muat ulang'), findsOneWidget);
  });

  testWidgets('membuka detail dengan informasi artikel', (tester) async {
    const article = Article(
      sourceName: 'Kabar Nusantara',
      author: 'Redaksi',
      title: 'Berita pilihan hari ini',
      description: 'Ringkasan berita pilihan.',
      publishedAt: '2026-11-13T02:00:00Z',
    );
    await tester.pumpWidget(
      MyApp(newsService: _SingleArticleNewsService(article)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(article.title));
    await tester.pumpAndSettle();

    expect(find.text('Detail berita'), findsOneWidget);
    expect(find.text(article.title), findsOneWidget);
    expect(find.text('Redaksi'), findsOneWidget);
    expect(find.text('Sumber: Kabar Nusantara'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tanggal terbit: 2026-11-13T02:00:00Z'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Tanggal terbit: 2026-11-13T02:00:00Z'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Ringkasan berita pilihan.'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Ringkasan berita pilihan.'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Baca selengkapnya'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Baca selengkapnya'), findsOneWidget);
  });

  testWidgets('detail menampilkan pengganti untuk informasi kosong', (
    tester,
  ) async {
    const article = Article(title: 'Berita tanpa informasi tambahan');
    await tester.pumpWidget(
      MyApp(newsService: _SingleArticleNewsService(article)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(article.title));
    await tester.pumpAndSettle();

    expect(find.text('Penulis tidak tersedia'), findsOneWidget);
    expect(find.text('Sumber: Sumber tidak tersedia'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Tanggal terbit: Tanggal tidak tersedia'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Tanggal terbit: Tanggal tidak tersedia'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Deskripsi tidak tersedia'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Deskripsi tidak tersedia'), findsOneWidget);
  });
}

class _SingleArticleNewsService implements NewsService {
  const _SingleArticleNewsService(this.article);

  final Article article;

  @override
  Future<List<Article>> fetchArticles() async => [article];
}
