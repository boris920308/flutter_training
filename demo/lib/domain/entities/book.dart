class Book {
  final String title;
  final String image;
  final String author;
  final String description;

  Book({
    required this.title,
    required this.image,
    required this.author,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: _stripHtml(json['title'] ?? ''),
      image: json['image'] ?? '',
      author: _stripHtml(json['author'] ?? '저자 미상'),
      description: _stripHtml(json['description'] ?? ''),
    );
  }

  Book toEntity() {
    return Book(
      title: title,
      image: image,
      author: author,
      description: description,
    );
  }

  // HTML 태그 제거 유틸리티
  static String _stripHtml(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>|&quot;'), '');
  }
}
