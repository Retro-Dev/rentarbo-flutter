import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/android.dart';

import '../Models/Earning.dart';

class LinearGraphView extends StatefulWidget {
  static const String route = "LinearGraphView";
  double? aspectRatio;
  Color? backgroundColors;
  Earning? earn;
  double? divider;

  //LineCharData Main Container
  static const Color? backgrounColor = Colors.white;

  //X Axies properties
  static const double? leftTitlesReverseSize = 25;
  static const double? leftTitleFontSize = 7;
  static const Color? leftTitleFontColor = Colors.black;
  static const bool? leftTilesShow = true;
  static const double? leftTileinterval = 1;

  //Y Axies Properties
  static const double? bottomTitleFontSize = 7;
  static const Color? bottomTiileFontColor = Colors.black;
  static const double? bottomTitlesReverseSize = 15;
  static const bool? bottomTitleShow = true;
  static const double? bottomTitleinterval = 1;

  //  LineChartData mainData
  static const bool? drawVerticalLine = false;
  static const bool? FlGridDatashow = true;
  static const bool? borderShow = false;
  static const double borderWidth = 1;
  static const Color borderColor = Colors.black;
  static const double? horizontalIntervalValue = 1;
  static const double? verticalIntervalValue = 1;
  static const Color? DrawingHorizontalLineColor = Colors.grey;
  static const double? DrawingHorizontalLineStrokeWidth = 0.3;
  static const Color? DrawingVerticalLineColor = Colors.grey;
  static const double? DrawingVerticalLineStrokeWidth = 0.3;

  LinearGraphView({this.aspectRatio , this.earn});

  @override
  _LinearGraphViewState createState() => _LinearGraphViewState();
}

class _LinearGraphViewState extends State<LinearGraphView> {
  List<Color> gradientColors = [
    Color.fromRGBO(234, 54, 63, 0.5),
    Color.fromRGBO(234, 54, 63, 0.5)
  ];

  List<Color> gradientColorsbg = [
    Color.fromRGBO(255, 155, 177, 1.0),
    Color.fromRGBO(234, 54, 63, 1.0)
  ];

  bool showAvg = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.divider = (double.parse(widget.earn?.earn?.total ?? "0.0"))/7;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: (widget.aspectRatio ?? 0.0),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: LinearGraphView.backgrounColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 0, bottom: 12),
              child: LineChart(
                 mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              if(mounted){
                setState(() {
                  showAvg = !showAvg;
                });
              }

            },
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 7,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: LinearGraphView.bottomTiileFontColor,
      fontWeight: FontWeight.bold,
      fontSize: LinearGraphView.bottomTitleFontSize,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: style);
        break;

      case 2:
        text = const Text('FEB', style: style);
        break;

      case 3:
        text = const Text('MAR', style: style);
        break;

      case 4:
        text = const Text('APR', style: style);
        break;

      case 5:
        text = const Text('MAY', style: style);
        break;

      case 6:
        text = const Text('JUN', style: style);
        break;

      case 7:
        text = const Text('JUL', style: style);
        break;


      case 8:
        text = const Text('AUG', style: style);
        break;

      case 9:
        text = const Text('SEP', style: style);
        break;

      case 10:
        text = const Text('OCT', style: style);
        break;

      case 11:
        text = const Text('NOV', style: style);
        break;

      case 12:
        text = const Text('Dec',style: style,);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: LinearGraphView.leftTitleFontColor,
      fontWeight: FontWeight.bold,
      fontSize: LinearGraphView.leftTitleFontSize,
    );
    String text;

        text = '${(value.toInt() * widget.divider!).round()}';


    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true, getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          final spot = barData.spots[spotIndex];

          return TouchedSpotIndicatorData(

            FlLine(color: gradientColors[1], strokeWidth: 4),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) {

                  return FlDotCirclePainter(
                      radius: 8,
                      color: Colors.white,
                      strokeWidth: 5,
                      strokeColor: gradientColors[1]);

              },
            ),
          );
        }).toList();
      },touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: gradientColors[1],
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;

              TextAlign textAlign;
              switch (flSpot.x.toInt()) {
                case 1:
                  textAlign = TextAlign.left;
                  break;
                case 5:
                  textAlign = TextAlign.right;
                  break;
                default:
                  textAlign = TextAlign.center;
              }

              return LineTooltipItem(
                '',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: (flSpot.y * widget!.divider!).toString(),
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                ],
                textAlign: textAlign,
              );
            }).toList();
          }),
      ),
      gridData: FlGridData(
        show: LinearGraphView.FlGridDatashow,
        drawVerticalLine: LinearGraphView.drawVerticalLine,
        horizontalInterval: LinearGraphView.horizontalIntervalValue,
        verticalInterval: LinearGraphView.verticalIntervalValue,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: LinearGraphView.DrawingHorizontalLineColor!.withOpacity(0.4),
            strokeWidth: LinearGraphView.DrawingHorizontalLineStrokeWidth,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: LinearGraphView.DrawingVerticalLineColor!.withOpacity(0.4),
            strokeWidth: LinearGraphView.DrawingVerticalLineStrokeWidth,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: LinearGraphView.bottomTitleShow,
            reservedSize: LinearGraphView.bottomTitlesReverseSize,
            interval: LinearGraphView.bottomTitleinterval,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: LinearGraphView.leftTilesShow,
            interval: LinearGraphView.leftTileinterval,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: LinearGraphView.leftTitlesReverseSize,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: LinearGraphView.borderShow,
          border: Border.all(
              color: LinearGraphView.borderColor,
              width: LinearGraphView.borderWidth)),
      minX: 0,
      maxX: 13,
      minY: 0,
      maxY: (double.parse(widget.earn?.earn?.total ?? "0.0") * 1.5)/widget.divider!,

      lineBarsData: [
        LineChartBarData(
          spots:
          [
            for (int i = 0 ; i < widget.earn!.earn!.graphData!.length! ; i++)
              FlSpot(double.parse(widget.earn!.earn!.graphData![i].months ?? "0.0"),  (double.parse(widget.earn!.earn!.graphData![i]!.earning ?? "0.0")) / widget.divider!),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 3.5,
                color: Colors.white,
                strokeWidth: 3.5,
                strokeColor: gradientColors[0],

              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColorsbg
                  .map((color) => color.withOpacity(0.05))
                  .toList(),
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }
}
