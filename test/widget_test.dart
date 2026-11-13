import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';
import 'package:news_app/services/mock_news_service.dart';

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
}
