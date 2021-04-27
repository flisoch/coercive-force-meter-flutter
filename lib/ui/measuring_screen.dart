import 'package:flutter/material.dart';

class MeasuringScreen extends StatefulWidget {
  const MeasuringScreen({Key key}) : super(key: key);

  @override
  _MeasuringState createState() => _MeasuringState();
}

class _MeasuringState extends State<MeasuringScreen> {
  bool hasMasks = true;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("qe"));
  }
}
