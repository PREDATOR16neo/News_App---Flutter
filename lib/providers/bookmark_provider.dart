import 'package:flutter/foundation.dart';

import '../models/article.dart';

class BookmarkProvider extends ChangeNotifier {
  final List<Article> _bookmarkedArticles = [];

  List<Article> get bookmarkedArticles =>
      List<Article>.unmodifiable(_bookmarkedArticles);

  // Provider menjaga perubahan bookmark di memori selama aplikasi berjalan.
  bool isBookmarked(Article article) => _bookmarkedArticles.contains(article);

  void toggleBookmark(Article article) {
    if (isBookmarked(article)) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }
}
