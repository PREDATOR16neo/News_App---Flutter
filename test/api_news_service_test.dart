import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:news_app/services/api_news_service.dart';

void main() {
  test('mengirim kategori pilihan dengan slug NewsAPI yang sesuai', () async {
    final requestedCategories = <String?>[];
    final client = MockClient((request) async {
      requestedCategories.add(request.url.queryParameters['category']);
      return http.Response('{"articles":[]}', 200);
    });
    addTearDown(client.close);

    final service = ApiNewsService(client: client, apiKey: 'test-key');
    const categories = {
      'Teknologi': 'technology',
      'Bisnis': 'business',
      'Olahraga': 'sports',
    };

    for (final category in categories.entries) {
      await service.fetchArticles(category: category.key);
    }
    await service.fetchArticles();

    expect(requestedCategories, ['technology', 'business', 'sports', null]);
  });
}
