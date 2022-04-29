import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as charts_text;
import 'package:charts_flutter/src/text_style.dart' as style;

class GraphOverlaySymbol extends charts.CircleSymbolRenderer {
  String value = '';

  void setValue(String v) {
    value = v;
  }

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      charts.Color? fillColor,
      charts.FillPatternType? fillPattern,
      charts.Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    canvas.drawRect(
        Rectangle(bounds.left - 10, bounds.top - 35, (bounds.width + 20) * 1.5,
            bounds.height + 20),
        fill: charts.MaterialPalette.gray.shadeDefault);

    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(charts_text.TextElement("$value", style: textStyle),
        (bounds.left).round(), (bounds.top - 28).round());
  }
}
