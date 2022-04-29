import 'dart:convert';
import 'package:flutter_book/data/book.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_book/constants/apis.dart' as Constants;
import 'package:flutter_book/data/book_entity.dart';
import 'package:flutter_book/data/book_read_info.dart';
import 'package:flutter_book/data/server_status.dart' as ServerStatus;

const String loadDomain = "aaaa";
const String naverDomain = "https://openapi.naver.com/v1/search";
const String naver_client_id = "ididid";
const String naver_client_secret = "secret";
const List book_query = [
  '경제흐름',
  '인문학',
  '히가시노게이고',
  '인간심리',
  '감사하기',
  '재테크',
  '철학',
  '커피',
  '습관',
  '드라이브',
  '휴식',
  '요리',
  '오늘',
  '자전거'
];

const int searchCount = 5;
const int searchResultCount = 20;

class ApiCall {
  static const Map<String, String> normalHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*",
  };

  static const Map<String, String> naverHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded',
    'X-Naver-Client-Id': Constants.naver_client_id,
    'X-Naver-Client-Secret': Constants.naver_client_secret
  };

  //읽을 예정 책 리스트
  static Future<List<Book>> getReservationBooks(String query) async {
    final urlRequest = Uri.parse(Constants.naverDomain + "/book.json").replace(
        queryParameters: {
          'query': query,
          'display': (Constants.searchCount).toString(),
          'start': '1'
        });

    http.Response response = await http.get(urlRequest, headers: naverHeaders);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return (data['items'] as List)
          .map((list) => Book.fromJson(list))
          .toList();
    }
    return List.empty();
  }

  //최근 읽은 책 리스트
  static Future<List<Book>> getRecentBooks() async {
    var response = await http.get(Uri.http(loadDomain, "/bookRating"),
        headers: normalHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map;
      return (data['result'] as List)
          .map((list) => Book.fromJson(list))
          .toList();
    }
    return List.empty();
  }

  //책 검색 결과 리스트
  static Future<BookEntity> searchBooks(
      String searchText, int searchCount, int pageIndex) async {
    final urlRequest = Uri.parse(Constants.naverDomain + "/book.json")
        .replace(queryParameters: {
      'query': searchText,
      'display': (searchCount).toString(),
      'start': (pageIndex).toString()
    });

    http.Response response = await http.get(urlRequest, headers: naverHeaders);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return BookEntity.fromJson(data);
    }
    return BookEntity.fromJson(Map());
  }

  //isbn 기반 감상평 상세 조회 리스트 - 결과가 성공 아니면 네이버 상세 api를 호출함
  static Future<Book> readDetailBook(String isbn) async {
    var response = await http.get(
        Uri.http(loadDomain, "/bookRating/isbn/$isbn"),
        headers: normalHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map;
      if (data['code'] == ServerStatus.SUCCESS) {
        return Book.fromJson(data['result']);
      }
    }
    return readNaverDetailBook(isbn);
  }

  //네이버 isbn으로 책 상세 검색
  static Future<Book> readNaverDetailBook(String isbn) async {
    final urlRequest = Uri.parse(Constants.naverDomain + "/book_adv.json")
        .replace(queryParameters: {
      'd_isbn': isbn,
    });

    http.Response response = await http.get(urlRequest, headers: naverHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Book.fromJson(data['items'][0])..isEmptyReview = true;
    }
    return Book.emptyBook();
  }

  //감상평 작성
  static Future<bool> createDetailBook(
      Book book, double rating, String summary) async {
    final sendQuery = jsonEncode({
      "title": book.title,
      "author": book.author,
      "isbn": book.isbn,
      "rating": rating,
      "image": book.image,
      "summary": summary,
      "publisher": book.publisher,
      "description": book.description
    });

    var response = await http.post(Uri.http(loadDomain, "/bookRating"),
        headers: normalHeaders, body: sendQuery);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map;
      return (data['code'] == ServerStatus.SUCCESS);
    }
    return false;
  }

  //감상평 삭제
  static Future<bool> deleteDetailBook(int id) async {
    var response = await http.delete(Uri.http(loadDomain, "/bookRating/$id"),
        headers: normalHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map;
      return (data['code'] == ServerStatus.SUCCESS);
    }
    return false;
  }

  //감상평 수정
  static Future<bool> updateDetailBook(
      Book book, double rating, String summary) async {
    final sendQuery = jsonEncode({
      "title": book.title,
      "author": book.author,
      "isbn": book.isbn,
      "rating": rating,
      "image": book.image,
      "summary": summary,
      "publisher": book.publisher,
      "description": book.description
    });

    var response = await http.put(
        Uri.http(loadDomain, "/bookRating/${book.id}"),
        headers: normalHeaders,
        body: sendQuery);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map;
      return (data['code'] == ServerStatus.SUCCESS);
    }
    return false;
  }

  //년도별 정보
  static Future<List<BookReadInfo>> getBookInfoByYear(int year) async {
    var response = await http.get(
        Uri.http(loadDomain, "/bookRating/info/$year"),
        headers: normalHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as Map;

      return (data['result'] as List)
          .map((list) => BookReadInfo.fromJson(list))
          .toList();
    }
    return List.empty();
  }
}
