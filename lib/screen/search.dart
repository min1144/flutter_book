import 'package:flutter/material.dart';
import 'package:flutter_book/constants/apis.dart';
import 'package:flutter_book/constants/routes.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/util/extension.dart';
import 'package:flutter_book/widget/empty_view.dart';
import 'package:flutter_book/widget/heading_title.dart';
import 'package:flutter_book/widget/responsive.dart';
import 'package:flutter_book/widget/top_bar.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:flutter_book/screen/books_detail.dart';

class Search extends StatefulWidget {
  final String searchText;

  const Search({Key? key, required this.searchText}) : super(key: key);

  @override
  _SearchState createState() => _SearchState(searchText: searchText);
}

class _SearchState extends State<Search> {
  List<Book> bookList = [];
  late String searchText;
  int totalPageCount = 0;
  bool isFirstLoading = false;

  _SearchState({required this.searchText});

  @override
  void initState() {
    super.initState();
    searchBooks(1);
  }

  void searchBooks(int pageIndex) {
    ApiCall.searchBooks(searchText, searchResultCount, pageIndex).then((value) {
      setState(() {
        totalPageCount = value.totalCount;
        bookList = value.bookList;
        if (!isFirstLoading) {
          isFirstLoading = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              backgroundColor: Colors.white,
              shape: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                APP_NAME,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  letterSpacing: 3,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBar(1.0)..isShowBack = true,
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            top: 150.0,
            bottom: 50.0,
            left: ResponsiveWidget.isSmallScreen(context) ? 20.0 : 150.0,
            right: ResponsiveWidget.isSmallScreen(context) ? 20.0 : 150.0),
        child: Column(
          children: [
            Image.asset('assets/home_4.webp',
                height: 400, width: screenSize.width, fit: BoxFit.cover),
            SizedBox(height: 100),
            HeadingTitle(title: '\'$searchText\' 검색 결과'),
            bookList.isNotEmpty
                ? GridView.builder(
                    itemCount: totalPageCount < searchResultCount
                        ? totalPageCount
                        : searchResultCount,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (screenSize.width ~/ 300).toInt(),
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BooksDetail(
                                        isbn: bookList[index].isbn,
                                      )))
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 112,
                              width: 82,
                              child: Image.network(
                                bookList[index].image,
                                fit: BoxFit.fitHeight,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/empty_book.webp',
                                      fit: BoxFit.contain);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenSize.height / 70,
                              ),
                              child: Text(
                                (bookList[index].title).omitString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 3,
                              ),
                              child: Text(
                                bookList[index].author,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: isFirstLoading == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [EmptyView(topMargin: 50.0)])
                        : Container()),
            bookList.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width / 6,
                      right: screenSize.width / 6,
                    ),
                    child: NumberPaginator(
                        buttonShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        buttonSelectedBackgroundColor: Color(0xFFEEEEEE),
                        buttonUnselectedForegroundColor: Colors.black,
                        buttonSelectedForegroundColor: Colors.black,
                        numberPages:
                            totalPageCount <= searchResultCount ? 1 : 10,
                        onPageChange: (int index) {
                          setState(() {
                            int pageIndex = index == 0
                                ? 1
                                : (searchResultCount * index + 1);
                            searchBooks(pageIndex);
                          });
                        }))
                : SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
