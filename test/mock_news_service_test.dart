import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/mock_news_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('memuat artikel contoh saat mode sukses', () async {
    final service = MockNewsService(delay: Duration.zero);

    final articles = await service.fetchArticles();

    expect(articles, hasLength(4));
    expect(articles.first, isA<Article>());
    expect(articles.first.title, 'Inovasi teknologi lokal terus berkembang');
    expect(
      articles.map((article) => article.category),
      containsAll(['Teknologi', 'Bisnis', 'Olahraga']),
    );
  });

  test('menghasilkan daftar kosong saat mode kosong', () async {
    final service = MockNewsService(
      responseMode: MockResponseMode.empty,
      delay: Duration.zero,
    );

    expect(await service.fetchArticles(), isEmpty);
  });

  test('memfilter artikel contoh berdasarkan kategori', () async {
    final service = MockNewsService(delay: Duration.zero);

    final articles = await service.fetchArticles(category: 'Bisnis');

    expect(articles, hasLength(1));
    expect(articles.single.category, 'Bisnis');
  });

  test('melempar error saat mode error', () async {
    final service = MockNewsService(
      responseMode: MockResponseMode.error,
      delay: Duration.zero,
    );

    await expectLater(service.fetchArticles(), throwsA(isA<Exception>()));
  });
}
