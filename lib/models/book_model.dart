class BookModel {
  final String bookId;
  final String title;
  final String author;
  final String? isbn;
  final String? category;
  final DateTime addedDate;

  BookModel({
    required this.bookId,
    required this.title,
    required this.author,
    this.isbn,
    this.category,
    required this.addedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': 'add_book',
      'book_id': bookId,
      'title': title,
      'author': author,
      'isbn': isbn ?? '',
      'category': category ?? '',
      'added_date': addedDate.toIso8601String(),
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      bookId: json['book_id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String?,
      category: json['category'] as String?,
      addedDate: DateTime.parse(json['added_date'] as String),
    );
  }
}
