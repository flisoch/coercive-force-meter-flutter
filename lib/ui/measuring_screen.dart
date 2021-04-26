import 'package:coercive_force_meter/bloc/measuring/bloc.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasuringScreen extends StatefulWidget {
  const MeasuringScreen({Key key}) : super(key: key);

  @override
  _MeasuringState createState() => _MeasuringState();
}

class _MeasuringState extends State<MeasuringScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasuringBloc, MeasuringState>(
      builder: (context, state) {
        print(state);
        Color backgroundColor = Colors.black;
        return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Center(child: Text("Коэрцитиметр")),
            ),
            body: _body(state, backgroundColor),
            backgroundColor: backgroundColor);
      },
    );
  }

  Widget _body(MeasuringState state, Color backgroundColor) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [Text("1: маска")],
              ),
              Column(
                children: [Text("2: Гаусс")],
              ),
            ],
          ),
          Row(),
        ],
      ),
    );
  }
}
