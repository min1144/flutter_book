import 'package:flutter/material.dart';
import 'package:flutter_book/constants/apis.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/util/extension.dart';
import 'package:flutter_book/widget/empty_view.dart';

import 'books_detail.dart';

class RecentBooks extends StatefulWidget {
  RecentBooks({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  RecentBookState createState() => RecentBookState();
}

class RecentBookState extends State<RecentBooks> {
  late Future<List<Book>> recentList;

  @override
  void initState() {
    super.initState();
    recentList = ApiCall.getRecentBooks();
  }

  int getSearchCount(int totalCount) {
    return totalCount < searchCount ? totalCount : searchCount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: recentList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...Iterable<int>.generate(getSearchCount(snapshot.data!.length))
                    .map(
                  (int pageIndex) => Expanded(
                    child: Container(
                      child: InkWell(
                        hoverColor: Colors.transparent,
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BooksDetail(
                                        isbn: snapshot.data![pageIndex].isbn,
                                      )))
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 112,
                              width: 82,
                              child: Image.network(
                                snapshot.data![pageIndex].image,
                                fit: BoxFit.fitHeight,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/empty_book.webp',
                                      fit: BoxFit.contain);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: widget.screenSize.height / 70,
                              ),
                              child: Text(
                                (snapshot.data![pageIndex].title).omitString(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 3,
                              ),
                              child: Text(
                                snapshot.data![pageIndex].author,
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
                      ),
                    ),
                  ),
                ),
              ]);
        }

        return const EmptyView(topMargin: 50.0);
      },
    );
  }
}
