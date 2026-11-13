import '../models/article.dart';

abstract class NewsService {
  // Future menandakan daftar berita akan tersedia setelah proses selesai.
  Future<List<Article>> fetchArticles({String? query, String? category});
}
