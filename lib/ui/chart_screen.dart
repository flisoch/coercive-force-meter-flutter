import 'package:coercive_force_meter/models/message.dart';
import 'package:coercive_force_meter/models/record.dart';
import 'package:coercive_force_meter/repository/FileStorage.dart';
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
    });
  }

  Widget _body() {
    return Row(
      children: [Text(record.measurements.length.toString())],
    );
  }
}
