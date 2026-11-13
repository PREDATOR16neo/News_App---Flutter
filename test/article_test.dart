import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('membaca artikel dari JSON contoh NewsAPI', () async {
    final jsonText = await rootBundle.loadString('assets/mock/articles.json');
    final response = jsonDecode(jsonText) as Map<String, dynamic>;
    final articlesJson = response['articles'] as List<dynamic>;

    final article = Article.fromJson(
      articlesJson.first as Map<String, dynamic>,
    );

    expect(article.sourceName, 'Kabar Nusantara');
    expect(article.author, 'Redaksi');
    expect(article.title, 'Inovasi teknologi lokal terus berkembang');
    expect(article.description, contains('inovasi baru'));
    expect(article.category, 'Teknologi');
    expect(article.url, 'https://example.com/teknologi-lokal');
    expect(article.urlToImage, 'https://example.com/images/teknologi.jpg');
    expect(article.publishedAt, '2026-11-13T02:00:00Z');
    expect(article.content, contains('pelaku lokal'));
  });

  test('menerima field opsional yang kosong atau tidak tersedia', () async {
    final jsonText = await rootBundle.loadString('assets/mock/articles.json');
    final response = jsonDecode(jsonText) as Map<String, dynamic>;
    final articlesJson = response['articles'] as List<dynamic>;

    final article = Article.fromJson(articlesJson[1] as Map<String, dynamic>);

    expect(article.title, 'Informasi dengan beberapa data kosong');
    expect(article.sourceName, isNull);
    expect(article.author, isNull);
    expect(article.description, isNull);
    expect(article.category, isNull);
    expect(article.url, isNull);
    expect(article.urlToImage, isNull);
    expect(article.publishedAt, isNull);
    expect(article.content, isNull);
  });

  test('menolak artikel tanpa judul', () {
    expect(
      () => Article.fromJson({'author': 'Redaksi'}),
      throwsA(isA<FormatException>()),
    );
  });
}
