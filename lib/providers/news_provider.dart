import 'package:flutter/foundation.dart';

import '../models/article.dart';
import '../services/news_service.dart';

enum NewsStatus { loading, success, error, empty }

class NewsProvider extends ChangeNotifier {
  NewsProvider(this._newsService);

  final NewsService _newsService;

  NewsStatus _status = NewsStatus.loading;
  List<Article> _articles = const [];
  Object? _error;
  String? _query;
  String? _category;
  int _requestVersion = 0;

  NewsStatus get status => _status;
  List<Article> get articles => _articles;
  Object? get error => _error;

  // Muat berita dengan filter agar pilihan kategori tetap diterapkan.
  Future<void> loadArticles({String? query, String? category}) async {
    _query = query;
    _category = category;
    await _fetchArticles();
  }

  Future<void> reloadArticles() => _fetchArticles();

  Future<void> _fetchArticles() async {
    final requestVersion = ++_requestVersion;
    final query = _query;
    final category = _category;
    final wasAlreadyLoading = _status == NewsStatus.loading;
    _status = NewsStatus.loading;
    _error = null;
    if (!wasAlreadyLoading) {
      notifyListeners();
    }

    try {
      final articles = await _newsService.fetchArticles(
        query: query,
        category: category,
      );
      if (requestVersion != _requestVersion) {
        return;
      }
      _articles = List<Article>.unmodifiable(articles);
      _status = articles.isEmpty ? NewsStatus.empty : NewsStatus.success;
    } catch (error) {
      if (requestVersion != _requestVersion) {
        return;
      }
      _error = error;
      _status = NewsStatus.error;
    }

    notifyListeners();
  }
}
