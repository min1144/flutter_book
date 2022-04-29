import 'package:flutter_book/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book/data/book.dart';
import 'package:flutter_book/widget/responsive.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late Future<List<Book>> reservationList;
  var msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Center(
      heightFactor: 1,
      child: Padding(
          padding: EdgeInsets.only(
            left: ResponsiveWidget.isSmallScreen(context)
                ? screenSize.width / 10
                : screenSize.width / 3,
            right: ResponsiveWidget.isSmallScreen(context)
                ? screenSize.width / 10
                : screenSize.width / 3,
          ),
          child: Container(
              padding:
                  const EdgeInsets.only(left: 0, top: 8, bottom: 8, right: 0),
              child: TextField(
                controller: msgController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) async {
                  Navigator.pushNamed(context, SEARCH,
                      arguments: {'searchText': value});
                  msgController.clear();
                },
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  hintText: 'Search Book',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 20.0, bottom: 20.0),
                      child: Icon(Icons.search, color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 5)),
                ),
                // ),
              ))),
    );
  }
}
