import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';
import 'news_exception.dart';
import 'news_service.dart';

class ApiNewsService implements NewsService {
  ApiNewsService({this.client, String? apiKey})
    : _apiKey = apiKey ?? const String.fromEnvironment('NEWS_API_KEY');

  static const _apiCategories = {
    'Bisnis': 'business',
    'Olahraga': 'sports',
    'Teknologi': 'technology',
  };

  final http.Client? client;
  final String _apiKey;

  // Tunggu respons API sebelum mengubah JSON menjadi daftar artikel.
  @override
  Future<List<Article>> fetchArticles({String? query, String? category}) async {
    if (_apiKey.isEmpty) {
      throw const NewsException(
        'API key belum diisi. Jalankan dengan --dart-define-fromfile=env.json',
      );
    }
    final apiCategory = category == null ? null : _apiCategories[category];
    if (category != null && apiCategory == null) {
      throw const NewsException('Kategori berita tidak dikenal.');
    }

    final uri = Uri.https('newsapi.org', '/v2/top-headlines', {
      'country': 'us',
      'pageSize': '20',
      'category': ?apiCategory,
      if (query != null && query.isNotEmpty) 'q': query,
    });
    final response =
        await (client?.get(uri, headers: {'X-Api-Key': _apiKey}) ??
                http.get(uri, headers: {'X-Api-Key': _apiKey}))
            .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw NewsException(_pesanError(response.statusCode));
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['articles'] as List<dynamic>? ?? [];
    return items
        .map((item) => Article.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  String _pesanError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid. Periksa parameter yang dikirim.';
      case 401:
        return 'API key salah atau tidak terkirim.';
      case 429:
        return 'Terlalu banyak permintaan atau kuota harian habis. Coba lagi nanti.';
      default:
        return 'Server bermasalah (kode $statusCode). Coba lagi nantis.';
    }
  }
}
