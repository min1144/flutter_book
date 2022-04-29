import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_book/constants/apis.dart';
import 'package:flutter_book/constants/routes.dart';
import 'package:flutter_book/data/book_read_info.dart';
import 'package:flutter_book/widget/graph_overlay_symbol.dart';
import 'package:flutter_book/widget/heading_title.dart';
import 'package:flutter_book/widget/responsive.dart';
import 'package:flutter_book/widget/top_bar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as charts_text;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:sprintf/sprintf.dart';

class History extends StatefulWidget {
  @override
  _History createState() => _History();
}

class _History extends State<History> {
  late Future<List<BookReadInfo>> readInfoList;
  List<charts.Series<BookReadInfo, String>> countGraphList = List.empty();
  List<charts.Series<BookReadInfo, String>> ratingGraphList = List.empty();

  final GraphOverlaySymbol readRenderer = GraphOverlaySymbol();
  final GraphOverlaySymbol ratingRenderer = GraphOverlaySymbol();
  late Size screenSize;

  @override
  void initState() {
    super.initState();
    screenSize = window.physicalSize;
    readInfoList = ApiCall.getBookInfoByYear(DateTime.now().year);
    readInfoList.then((value) {
      countGraphList = [
        charts.Series(
            id: "readCount",
            data: value,
            domainFn: (BookReadInfo series, _) => series.month,
            measureFn: (BookReadInfo series, _) => series.readBookCount,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault)
      ];

      ratingGraphList = [
        charts.Series(
          id: 'ratingBook',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (BookReadInfo sales, _) => sales.month,
          measureFn: (BookReadInfo sales, _) => sales.averageRating,
          data: value,
        )
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<BookReadInfo>>(
          future: readInfoList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    vertical: 150.0,
                    horizontal:
                        ResponsiveWidget.isSmallScreen(context) ? 20.0 : 150.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/home_3.webp',
                      height: 400,
                      width: screenSize.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 100),
                    HeadingTitle(
                        title: sprintf('%d년도 읽은 권수', [DateTime.now().year])),
                    SizedBox(height: 50),
                    Container(
                      height: 300,
                      child: charts.BarChart(
                        countGraphList,
                        animate: false,
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (charts.SelectionModel model) {
                            if (model.hasDatumSelection) {
                              final value = model.selectedSeries[0]
                                  .measureFn(model.selectedDatum[0].index);
                              readRenderer.setValue("$value권");
                            }
                          })
                        ],
                        behaviors: [
                          charts.LinePointHighlighter(
                              symbolRenderer: readRenderer)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    HeadingTitle(
                        title: sprintf('%d년도 월별 평점', [DateTime.now().year])),
                    SizedBox(height: 50),
                    Container(
                      height: 300,
                      child: charts.BarChart(
                        ratingGraphList,
                        animate: false,
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (charts.SelectionModel model) {
                            if (model.hasDatumSelection) {
                              final value = model.selectedSeries[0]
                                  .measureFn(model.selectedDatum[0].index);
                              ratingRenderer.setValue(value.toString());
                            }
                          })
                        ],
                        behaviors: [
                          charts.LinePointHighlighter(
                              symbolRenderer: ratingRenderer)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
