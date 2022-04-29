import 'package:flutter/material.dart';
import 'package:flutter_book/constants/apis.dart';
import 'package:flutter_book/constants/routes.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/util/extension.dart';
import 'package:flutter_book/widget/heading_title.dart';
import 'package:flutter_book/widget/responsive.dart';
import 'package:flutter_book/widget/top_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_html/flutter_html.dart';

class BooksDetail extends StatefulWidget {
  final String isbn;

  const BooksDetail({Key? key, required this.isbn}) : super(key: key);

  @override
  _BooksDetail createState() => _BooksDetail(isbn: isbn);
}

class _BooksDetail extends State<BooksDetail> {
  final TextEditingController _textEditingController = TextEditingController();
  late String isbn;
  late Future<Book> detailBook;
  double rating = 0.0;
  bool isFirstLoading = false;

  _BooksDetail({required this.isbn});

  @override
  void initState() {
    super.initState();
    detailBook = ApiCall.readDetailBook(isbn);
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
              title: const Text(
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
      body: FutureBuilder<Book>(
          future: detailBook,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!isFirstLoading) {
                _textEditingController.value =
                    TextEditingValue(text: snapshot.data!.summary);
                rating = snapshot.data!.rating;
                isFirstLoading = true;
              }

              return Stack(children: [
                SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: 150.0,
                        bottom: 50,
                        left: ResponsiveWidget.isSmallScreen(context)
                            ? 20.0
                            : 150.0,
                        right: ResponsiveWidget.isSmallScreen(context)
                            ? 20.0
                            : 150.0),
                    child: Column(
                      children: [
                        Image.asset('assets/home_2.webp',
                            height: 400,
                            width: screenSize.width,
                            fit: BoxFit.cover),

                        SizedBox(height: 100),
                        HeadingTitle(
                          title: snapshot.data!.isEmptyReview
                              ? '감상평이 없어요. 작성해 주세요.'
                              : '${(snapshot.data!.createDate).changeLocalTime()}에 작성한 글 입니다',
                        ),
                        SizedBox(height: 50),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 112,
                              width: 82,
                              child: Image.network(
                                snapshot.data!.image,
                                fit: BoxFit.fitHeight,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/empty_book.webp',
                                      fit: BoxFit.contain);
                                },
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                                flex: 1,
                                child: LimitedBox(
                                  maxWidth: screenSize.width * 0.7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${snapshot.data!.author} ｜ ${snapshot.data!.publisher}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Montserrat',
                                            color: Colors.black54),
                                      ),
                                      SizedBox(height: 10),
                                      Html(
                                          data: snapshot.data!.description,
                                          style: {}),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 30),

                        //
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: RatingBar.builder(
                                initialRating: snapshot.data!.rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                unratedColor:
                                    Colors.grey.shade700.withAlpha(50),
                                itemBuilder: (context, _) => Icon(Icons.star,
                                    color: Colors.grey.shade700),
                                onRatingUpdate: (rating) {
                                  this.rating = rating;
                                },
                              ),
                            ),
                          ],
                        ),

                        //
                        SizedBox(height: 30),
                        Container(
                          height: 500,
                          child: TextFormField(
                            controller: _textEditingController,
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Montserrat',
                                color: Colors.black),
                            maxLength: 3000,
                            decoration: InputDecoration(
                                hintText: "감상평을 적어주세요.",
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)))),
                            minLines: 30,
                            maxLines: 30,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        SizedBox(height: 30),

                        Visibility(
                          visible: !snapshot.data!.isEmptyReview,
                          child: SizedBox(
                            height: 50,
                            width: 120,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onPressed: () => {
                                createAlertDialog('작성한 내용을 삭제하시겠습니까?', () {
                                  ApiCall.deleteDetailBook(snapshot.data!.id)
                                      .then((result) => {
                                            if (result)
                                              {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop()
                                              }
                                          });
                                })
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                              label: const Text(
                                'DELETE',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),

                //
                Align(
                  alignment: FractionalOffset(0.97, 0.97),
                  child: SizedBox(
                    height: 50,
                    width: 120,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onPressed: () => {
                        if (checkReviewEmpty())
                          {createAlertDialog('평점이나 감상평을 작성해주세요.', () {})}
                        else
                          {checkReviewWriteOrEdit(snapshot.data!)}
                      },
                      icon: Icon(
                          snapshot.data!.isEmptyReview
                              ? Icons.save
                              : Icons.edit,
                          color: Colors.black),
                      label: Text(
                        snapshot.data!.isEmptyReview ? 'SAVE' : 'EDIT',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                )
              ]);
            } else {
              return Container();
            }
          }),
    );
  }

  void createAlertDialog(String title, Function pressed) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
            actionsOverflowButtonSpacing: 20,
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade200),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.black),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade200),
                  ),
                  onPressed: () {
                    pressed();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child:
                      const Text('확인', style: TextStyle(color: Colors.black))),
            ],
          );
        });
  }

  bool checkReviewEmpty() {
    return (rating == 0.0 || _textEditingController.text.trim().isEmpty);
  }

  void checkReviewWriteOrEdit(Book book) {
    createAlertDialog(
        book.isEmptyReview ? '작성한 내용을 저장하시겠습니까?' : '작성한 내용을 수정하시겠습니까?', () {
      if (book.isEmptyReview) {
        createReviewWrite(book);
      } else {
        updateReviewWrite(book);
      }
    });
  }

  void createReviewWrite(Book book) async {
    ApiCall.createDetailBook(book, rating, _textEditingController.text.trim())
        .then((result) => {createAlertDialog('작성한 내용을 저장하였습니다.', () {})});
  }

  void updateReviewWrite(Book book) async {
    ApiCall.updateDetailBook(book, rating, _textEditingController.text.trim())
        .then((result) => {createAlertDialog('작성한 내용을 수정하였습니다.', () {})});
  }
}
