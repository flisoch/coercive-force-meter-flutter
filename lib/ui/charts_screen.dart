import 'package:coercive_force_meter/models/record.dart';
import 'package:coercive_force_meter/routes.dart';
import 'package:flutter/material.dart';

class ChartsScreen extends StatefulWidget {
  final List<Record> records;

  ChartsScreen({this.records});

  @override
  _ChartsState createState() => _ChartsState(records: this.records);
}

class _ChartsState extends State<ChartsScreen> {
  final List<Record> records;
  Color backgroundColor = Colors.blueAccent;

  _ChartsState({this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Графики измерений'),
        backgroundColor: backgroundColor,
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('${records[index].sampleName}'),
            onTap: () {
              Navigator.pushNamed(context, Routes.chart,
                  arguments: {"record-name": records[index].sampleName});
            },
          );
        },
      ),
    );
  }
}
