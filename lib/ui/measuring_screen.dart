import 'package:coercive_force_meter/bloc/measuring/bloc.dart';
import 'package:coercive_force_meter/bloc/measuring/events.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:coercive_force_meter/models/measuring_type.dart';
import 'package:coercive_force_meter/wifi_connection/message_protocol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasuringScreen extends StatefulWidget {
  MeasuringType measuringType;
  String mask;

  MeasuringScreen(Map<String, dynamic> args) {
    measuringType = args["type"];
    mask = args["mask"];
  }

  @override
  _MeasuringState createState() =>
      _MeasuringState(this.measuringType, this.mask);
}

class _MeasuringState extends State<MeasuringScreen> {
  final MeasuringType measuringType;
  final String mask;

  double progressionValue = 0;
  final int N = 4;

  _MeasuringState(this.measuringType, this.mask);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MeasuringBloc(MeasuringIdleState()),
      child: BlocBuilder<MeasuringBloc, MeasuringState>(
        builder: (context, state) {
          print('Measuring Screen: $state');
          if (state is MeasuringIdleState) {
            if (measuringType == MeasuringType.GAUSS) {
              MeasuringEvent event = MeasuringStartEvent(
                   topic: Topic.gauss.toShortString(), message: mask);
              BlocProvider.of<MeasuringBloc>(context).add(event);
            }
          }
          if (state is MeasuringReceivedMessageState) {
            progressionValue = state.messagesReceived / N;
          }
          if (state is MeasuringFinishedState) {
            progressionValue = 1;
            // todo: change button from "Stop" to Ok  and add another button to see results
          }
          Color backgroundColor = Colors.blueAccent;
          String title = measuringType == MeasuringType.GAUSS
              ? "Гаусс"
              : measuringType == MeasuringType.NEW_MASK
                  ? "Генерация Маски"
                  : "Размагничивание";
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: backgroundColor,
                title: Text(title),
              ),
              body: _body(Colors.white),
              backgroundColor: Colors.white);
        },
      ),
    );
  }

  Widget _body(Color backgroundColor) {
    return Column(
        children: [_description(), _progressionIndicator(), _stopButton()]);
  }

  Widget _description() {
    return Container(
        margin: EdgeInsets.only(top: 250),
        padding: EdgeInsets.all(10),
        child: Text("Процесс выполняется...", style: TextStyle(fontSize: 16),));
  }

  Widget _progressionIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: LinearProgressIndicator(
          value: progressionValue,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.blueAccent,
            // Colors.white,
          )),
    );
  }

  Widget _stopButton() {
    return Container(
        margin: EdgeInsets.only(left: 55, top: 150, right: 55),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: Colors.blueAccent),
                onPressed: () {
                  print('stop button pressed');
                },
                child: Text("Остановить"),
              ),
            )
          ],
        ));
  }
}
