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

  _ChartsState({this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.chart,
                arguments: {"record": records[index]});
          },
        );
      },
    );
  }
}
