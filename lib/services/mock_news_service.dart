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
  Future<List<Article>> fetchArticles({String? query, String? category}) async {
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

    final articles = articlesJson.map((articleJson) {
      if (articleJson is! Map<String, dynamic>) {
        throw const FormatException('Setiap berita harus berupa objek JSON.');
      }
      return Article.fromJson(articleJson);
    }).toList();

    return articles.where((article) {
      final matchesCategory =
          category == null ||
          article.category?.toLowerCase() == category.toLowerCase();
      final searchableText = [
        article.title,
        article.description ?? '',
        article.sourceName ?? '',
        article.author ?? '',
      ].join(' ').toLowerCase();
      final matchesQuery =
          query == null ||
          query.trim().isEmpty ||
          searchableText.contains(query.trim().toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }
}
