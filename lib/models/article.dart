class Article {
  const Article({
    this.sourceName,
    this.author,
    required this.title,
    this.description,
    this.category,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  final String? sourceName;
  final String? author;
  final String title;
  final String? description;
  final String? category;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  // Mengubah data JSON NewsAPI menjadi model Article yang aman terhadap null.
  factory Article.fromJson(Map<String, dynamic> json) {
    final title = _readOptionalString(json, 'title');
    if (title == null) {
      throw const FormatException('Field "title" wajib diisi.');
    }

    String? sourceName;
    final source = json['source'];
    if (source != null) {
      if (source is! Map<String, dynamic>) {
        throw const FormatException(
          'Field "source" harus berupa objek atau null.',
        );
      }
      sourceName = _readOptionalString(source, 'name');
    }

    return Article(
      sourceName: sourceName,
      author: _readOptionalString(json, 'author'),
      title: title,
      description: _readOptionalString(json, 'description'),
      category: _readOptionalString(json, 'category'),
      url: _readOptionalString(json, 'url'),
      urlToImage: _readOptionalString(json, 'urlToImage'),
      publishedAt: _readOptionalString(json, 'publishedAt'),
      content: _readOptionalString(json, 'content'),
    );
  }

  static String? _readOptionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw FormatException('Field "$key" harus berupa teks atau null.');
    }
    return value;
  }
}
