import 'book.dart';

class BookEntity {
  final int totalCount;
  final List<Book> bookList;

  BookEntity({required this.totalCount, required this.bookList});

  factory BookEntity.fromJson(Map<String, dynamic> json) {
    return BookEntity(
        totalCount: json['total'] ?? 0,
        bookList: (json['items'] as List)
            .map((list) => Book.fromJson(list))
            .toList());
  }
}
