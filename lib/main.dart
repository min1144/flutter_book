import 'package:flutter/material.dart';
import 'package:flutter_book/screen/books_detail.dart';
import 'package:flutter_book/screen/history.dart';
import 'package:flutter_book/screen/home.dart';
import 'package:flutter_book/screen/search.dart';
import 'package:flutter_book/constants/routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'NotoSans',
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: HOME,
      onGenerateRoute: (settings) {
        if (settings.name == SEARCH) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return Search(
                searchText: args["searchText"],
              );
            },
          );
        } else if (settings.name == DETAIL) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return BooksDetail(
                isbn: args["isbn"],
              );
            },
          );
        }
      },
      routes: {
        HOME: (context) => Home(),
        HISTORY: (context) => History(),
      },
    );
  }
}
