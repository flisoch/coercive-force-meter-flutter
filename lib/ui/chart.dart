import 'package:coercive_force_meter/models/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final Record record;

  const Chart({Key key, this.record}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChartState(record: record);
  }
}

class _ChartState extends State<Chart> {
  final Record record;
  Color backgroundColor = Colors.blueAccent;
  _ChartState({this.record});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(record.sampleName), backgroundColor: backgroundColor,),
    );
  }
}
