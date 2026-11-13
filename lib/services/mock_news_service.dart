import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/article.dart';
import 'news_service.dart';

enum MockResponseMode { success, error, empty }

class MockNewsService implements NewsService {
  MockNewsService({
    this.responseMode = MockResponseMode.success,
    this.delay = const Duration(seconds: 1),
  }) : assert(!delay.isNegative, 'Jeda tidak boleh bernilai negatif.');

  final MockResponseMode responseMode;
  final Duration delay;

  @override
  Future<List<Article>> fetchArticles() async {
    // Simulasikan waktu tunggu agar state loading dapat diuji.
    await Future<void>.delayed(delay);

    switch (responseMode) {
      case MockResponseMode.error:
        throw Exception('Simulasi gagal memuat berita.');
      case MockResponseMode.empty:
        return [];
      case MockResponseMode.success:
        break;
    }

    final jsonText = await rootBundle.loadString('assets/mock/articles.json');
    final decodedJson = jsonDecode(jsonText);
    if (decodedJson is! Map<String, dynamic>) {
      throw const FormatException('Data berita harus berupa objek JSON.');
    }

    final articlesJson = decodedJson['articles'];
    if (articlesJson is! List<dynamic>) {
      throw const FormatException('Field "articles" harus berupa daftar.');
    }

    return articlesJson.map((articleJson) {
      if (articleJson is! Map<String, dynamic>) {
        throw const FormatException('Setiap berita harus berupa objek JSON.');
      }
      return Article.fromJson(articleJson);
    }).toList();
  }
}
