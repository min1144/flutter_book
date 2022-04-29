import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_book/constants/apis.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/screen/books_detail.dart';
import 'package:flutter_book/util/extension.dart';

class ReservationBook extends StatefulWidget {
  ReservationBook({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  ReservationBookState createState() => ReservationBookState();
}

class ReservationBookState extends State<ReservationBook> {
  late Future<List<Book>> reservationList;

  String findSearchQuery() {
    var random = Random();
    var num = random.nextInt(14);
    return book_query[num];
  }

  @override
  void initState() {
    super.initState();
    reservationList = ApiCall.getReservationBooks(findSearchQuery());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: reservationList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...Iterable<int>.generate(searchCount).map(
                (int pageIndex) => Expanded(
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
            ],
          );
        }
        return Container();
      },
    );
  }
}
