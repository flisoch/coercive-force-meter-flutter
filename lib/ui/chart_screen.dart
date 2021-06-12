import 'package:coercive_force_meter/models/message.dart';
import 'package:coercive_force_meter/models/record.dart';
import 'package:coercive_force_meter/repository/FileStorage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatefulWidget {
  String recordName;

  ChartScreen(Map<String, dynamic> args) {
    recordName = args["record-name"];
  }

  @override
  State<StatefulWidget> createState() {
    return _ChartScreenState(recordName: recordName);
  }
}

class _ChartScreenState extends State<ChartScreen> {
  final String recordName;
  Record record;
  List<FlSpot> inductiveSpots = [];
  List<FlSpot> remanenceSpots = [];
  Color backgroundColor = Colors.blueAccent;

  _ChartScreenState({this.recordName});

  @override
  void initState() {
    super.initState();
    getRecord();
  }

  @override
  Widget build(BuildContext context) {
    if (record == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(record.sampleName),
          backgroundColor: backgroundColor,
        ),
        body: _body(),
      );
    }
  }

  void getRecord() async {
    FileStorage fileStorage = FileStorage();
    await fileStorage.init();
    List<Message> dataPoints = await fileStorage.readMessages("gem.txt");
    setState(() {
      record = Record(sampleName: recordName, measurements: dataPoints);
      initSpots(record.measurements);
    });
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 22.0, bottom: 20),
        child: SizedBox(
          width: 400,
          height: 400,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    tooltipBgColor: Colors.orange,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.colors[0],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                            '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                            textStyle);
                      }).toList();
                    }),
                handleBuiltInTouches: true,
                getTouchLineStart: (data, index) => 0,
              ),
              lineBarsData: [
                LineChartBarData(
                  colors: [
                    Colors.lightBlue,
                  ],
                  spots: inductiveSpots,
                  isCurved: true,
                  // isStrokeCapRound: true,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                  dotData: FlDotData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTextStyles: (value) => const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  margin: 16,
                  interval: 0.01,
                  getTitles: (value) {
                    int v = (value * 100).round();
                    switch (v) {
                      case -25:
                        return "-0.25";
                      case -20:
                        return "-0.2";
                      case -15:
                        return "-0.15";
                      case -10:
                        return "-0.1";
                      case -5:
                        return "-0.05";
                      case 0:
                        return "0";
                      case 5:
                        return "0.05";
                      case 10:
                        return "0.1";
                      case 15:
                        return "0.15";
                      case 20:
                        return "0.2";
                      case 25:
                        return "0.25";
                    }
                    return "";
                  },
                ),
                rightTitles: SideTitles(showTitles: false),
                bottomTitles: SideTitles(
                  interval: 100,
                  getTitles: (value) {
                    print(value);
                    int v = value.ceil();
                    print(v);
                    switch (v) {
                      case -800:
                        return "-800";
                      case -600:
                        return "-600";
                      case -400:
                        return "-400";
                      case -200:
                        return "-200";
                      case 0:
                        return "0";
                      case 200:
                        return "200";
                      case 400:
                        return "400";
                      case 600:
                        return "600";
                      case 800:
                        return "800";
                    }
                    return "";
                  },
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  margin: 16,
                ),
                topTitles: SideTitles(showTitles: false),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: true,
                horizontalInterval: 0.5,
                verticalInterval: 0.5,
                checkToShowHorizontalLine: (value) {
                  return value.toInt() == 0;
                },
                checkToShowVerticalLine: (value) {
                  return value.toInt() == 0;
                },
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  void initSpots(List<Message> measurements) {
    measurements.forEach((element) {
      remanenceSpots.add(FlSpot(element.H, element.Jr));
      inductiveSpots.add(FlSpot(element.H, element.Ji));
    });
  }
}
