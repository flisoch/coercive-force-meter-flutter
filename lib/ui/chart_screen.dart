import 'package:coercive_force_meter/models/message.dart';
import 'package:coercive_force_meter/models/record.dart';
import 'package:coercive_force_meter/repository/file_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
          title: Text("Графики измерений"),
          backgroundColor: backgroundColor,
        ),
        body: _body(),
      );
    }
  }

  void getRecord() async {
    FileStorage fileStorage = FileStorage();
    await fileStorage.init();
    List<Message> dataPoints = await fileStorage.readMessages(recordName);
    setState(() {
      record = Record(sampleName: recordName, measurements: dataPoints);
      initSpots(record.measurements);
    });
  }

  Widget _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Expanded(
                flex: 0,
                child: new RotatedBox(
                  quarterTurns: 3,
                  child: new Text("Ji [mA*m^2]"),
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Индуктивная намагниченность',
                          style: TextStyle(
                            color: Color(0xff827daa),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(children: [
                      igrapgh(),
                    ])
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 0,
                child: new RotatedBox(
                  quarterTurns: 3,
                  child: new Text("Jr [mA*m^2]"),
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Остаточная намагниченность',
                          style: TextStyle(
                            color: Color(0xff827daa),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(children: [
                      ggrapgh(),
                    ])
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void initSpots(List<Message> measurements) {
    measurements.forEach((element) {
      remanenceSpots.add(FlSpot(element.H, element.Jr));
      inductiveSpots.add(FlSpot(element.H, element.Ji));
    });
  }

  Widget igrapgh() {
    return SizedBox(
      height: 350,
      width: 390,
      child: Padding(
        padding: const EdgeInsets.only(right: 22.0, bottom: 20, left: 20),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  // maxContentWidth: 100,
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
            // todo: calculate axis max
            minX: -800,
            maxX: 800,
            minY: -0.2,
            maxY: 0.25,
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 16,
                interval: 0.05,
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
                // todo: calculate interval so that only 8-9 numbers are shown
                interval: 200,
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 14,
              ),
              topTitles: SideTitles(showTitles: false),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 1.5,
              verticalInterval: 5,
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
    );
  }

  Widget ggrapgh() {
    return SizedBox(
      height: 350,
      width: 390,
      child: Padding(
        padding: const EdgeInsets.only(right: 22.0, bottom: 20, left: 20),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  // maxContentWidth: 100,
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
                spots: remanenceSpots,
                isCurved: true,
                // isStrokeCapRound: true,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: false,
                ),
                dotData: FlDotData(show: false),
              ),
            ],
            // todo: calculate axis max
            minX: -800,
            maxX: 800,
            minY: -0.06,
            maxY: 0.08,
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 16,
                interval: 0.02,
                getTitles: (value) {
                  int v = (value * 100).round();
                  switch (v) {
                    case -6:
                      return "-0.06";
                    case -4:
                      return "-0.04";
                    case -2:
                      return "-0.02";
                    case 0:
                      return "0";
                    case 2:
                      return "0.02";
                    case 4:
                      return "0.04";
                    case 6:
                      return "0.06";
                    case 8:
                      return "0.8";
                  }
                  return "";
                },
              ),
              rightTitles: SideTitles(showTitles: false),
              bottomTitles: SideTitles(
                // todo: calculate interval so that only 8-9 numbers are shown
                interval: 200,
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 14,
              ),
              topTitles: SideTitles(showTitles: false),
            ),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 1.5,
              verticalInterval: 5,
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
    );
  }

  Widget rgraph() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 22.0, bottom: 20, left: 20),
        child: SizedBox(
          width: 350,
          height: 350,
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
                  spots: remanenceSpots,
                  isCurved: true,
                  // isStrokeCapRound: true,
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                  dotData: FlDotData(show: false),
                ),
              ],
              // todo: calculate axis max
              minX: -800,
              maxX: 800,
              minY: -0.06,
              maxY: 0.08,
              titlesData: FlTitlesData(
                leftTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTextStyles: (value) => const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  margin: 16,
                  interval: 0.02,
                  getTitles: (value) {
                    int v = (value * 100).round();
                    switch (v) {
                      case -6:
                        return "-0.06";
                      case -4:
                        return "-0.04";
                      case -2:
                        return "-0.02";
                      case 0:
                        return "0";
                      case 2:
                        return "0.02";
                      case 4:
                        return "0.04";
                      case 6:
                        return "0.06";
                      case 8:
                        return "0.8";
                    }
                    return "";
                  },
                ),
                rightTitles: SideTitles(showTitles: false),
                bottomTitles: SideTitles(
                  // todo: calculate interval so that only 8-9 numbers are shown
                  interval: 200,
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  margin: 14,
                ),
                topTitles: SideTitles(showTitles: false),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 1.5,
                verticalInterval: 5,
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
}
