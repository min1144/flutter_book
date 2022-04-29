import 'package:flutter/material.dart';
import 'package:flutter_book/constants/routes.dart';
import 'package:flutter_book/screen/recent_books.dart';
import 'package:flutter_book/screen/reservation_books.dart';
import 'package:flutter_book/widget/bottom_bar.dart';
import 'package:flutter_book/widget/heading_title.dart';
import 'package:flutter_book/widget/search_input.dart';
import 'package:flutter_book/widget/responsive.dart';
import 'package:flutter_book/widget/top_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            )
          : PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBar(1.0),
            ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: 150.0,
                        left: ResponsiveWidget.isSmallScreen(context)
                            ? 20.0
                            : 150.0,
                        right: ResponsiveWidget.isSmallScreen(context)
                            ? 20.0
                            : 150.0),
                    child: Image.asset(
                      'assets/home_1.webp',
                      height: 400,
                      width: screenSize.width,
                      fit: BoxFit.fill,
                    )),
                SizedBox(height: 100),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.isSmallScreen(context)
                          ? 20.0
                          : 150.0),
                  child: HeadingTitle(title: '최근 읽은 책'),
                ),
                SizedBox(height: 50),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveWidget.isSmallScreen(context)
                            ? 20.0
                            : 150.0),
                    child: RecentBooks(screenSize: screenSize)),
                SizedBox(height: 150),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.isSmallScreen(context)
                          ? 20.0
                          : 150.0),
                  child: HeadingTitle(title: '읽을 예정 책'),
                ),
                SizedBox(height: 50),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveWidget.isSmallScreen(context)
                            ? 20.0
                            : 150.0),
                    child: ReservationBook(screenSize: screenSize)),
                SizedBox(height: 150),
                BottomBar(),
              ],
            ),
            Positioned.fill(
              child:
                  Align(alignment: Alignment.topCenter, child: SearchInput()),
              top: 500,
            ),
          ],
        ),
      ),
    );
  }
}
