import 'package:flutter_book/util/extension.dart';

class Book {
  int _id = 0;
  String _summary = '';
  double _rating = 0.0;
  String _createDate = '';
  String _updateDate = '';
  String _description = '';
  bool _isEmptyReview = false;

  final String title;
  final String image;
  final String author;
  final String publisher;
  final String isbn;

  Book(
      {required this.title,
      required this.image,
      required this.author,
      required this.publisher,
      required this.isbn});

  int get id => _id;
  set id(int value) {
    _id = value;
  }

  String get summary => _summary;
  set summary(String value) {
    _summary = value;
  }

  String get createDate => _createDate;
  set createDate(String value) {
    _createDate = value;
  }

  String get updateDate => _updateDate;
  set updateDate(String value) {
    _updateDate = value;
  }

  String get description => _description;
  set description(String value) {
    _description = value;
  }

  double get rating => _rating;
  set rating(double value) {
    _rating = value;
  }

  bool get isEmptyReview => _isEmptyReview;
  set isEmptyReview(bool value) {
    _isEmptyReview = value;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        title: json['title'],
        image: json.containsKey('image') ? json['image'] : '',
        author: (json['author'] as String).removeAllHtmlTags(),
        publisher: json['publisher'],
        isbn: json['isbn'])
      ..id = json.containsKey('id') ? json['id'] : 0
      ..rating = json.containsKey('rating') ? json['rating'] : 0.0
      ..summary = json.containsKey('summary') ? json['summary'] : ''
      ..createDate = json.containsKey('createDate') ? json['createDate'] : ''
      ..updateDate = json.containsKey('updateDate') ? json['updateDate'] : ''
      ..description =
          json.containsKey('description') ? json['description'] : '';
  }

  factory Book.emptyBook() {
    return Book(title: '', image: '', author: '', publisher: '', isbn: '');
  }
}
