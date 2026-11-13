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

  NewsStatus get status => _status;
  List<Article> get articles => _articles;
  Object? get error => _error;

  // async/await waits for NewsService, then publishes its result as a state.
  Future<void> loadArticles() async {
    final wasAlreadyLoading = _status == NewsStatus.loading;
    _status = NewsStatus.loading;
    _error = null;
    if (!wasAlreadyLoading) {
      notifyListeners();
    }

    try {
      final articles = await _newsService.fetchArticles();
      _articles = List<Article>.unmodifiable(articles);
      _status = articles.isEmpty ? NewsStatus.empty : NewsStatus.success;
    } catch (error) {
      _error = error;
      _status = NewsStatus.error;
    }

    notifyListeners();
  }
}
