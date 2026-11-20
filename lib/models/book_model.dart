class BookModel {
  final int number;
  final String title;
  final String originalTitle;
  final String releaseDate;
  final String description;
  final int pages;
  final String cover;
  final int index;

  BookModel({
    required this.number,
    required this.title,
    required this.originalTitle,
    required this.releaseDate,
    required this.description,
    required this.pages,
    required this.cover,
    required this.index,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      number: (json['number'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      originalTitle: json['originalTitle'] as String? ?? '',
      releaseDate: json['releaseDate'] as String? ?? '',
      description: json['description'] as String? ?? '',
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      cover: json['cover'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'originalTitle': originalTitle,
      'releaseDate': releaseDate,
      'description': description,
      'pages': pages,
      'cover': cover,
      'index': index,
    };
  }
}
