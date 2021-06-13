import 'package:coercive_force_meter/bloc/measuring/bloc.dart';
import 'package:coercive_force_meter/bloc/measuring/events.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:coercive_force_meter/models/measuring_type.dart';
import 'package:coercive_force_meter/wifi_connection/message_protocol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../routes.dart';

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
  Text descriptionText;
  ElevatedButton button;
  double progressionValue = 0;

  _MeasuringState(this.measuringType, this.mask);

  @override
  void initState() {
    descriptionText = _descriptionProgressText();
    button = _progressButton();
    super.initState();
  }

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
            progressionValue = state.messagesReceived / GaussPointsAmount;
            print(progressionValue);
            if (GaussPointsAmount - state.messagesReceived < 5) {
              // print("IM HERE");
              // MeasuringEvent event = MeasuringFinishEvent();
              // BlocProvider.of<MeasuringBloc>(context).add(event);
            }
          }
          if (state is MeasuringFinishedState) {
            print("STATE IS $state");
            progressionValue = 1;
            descriptionText = _descriptionFinishedText();
            button = _finishedButton(state.recordName);

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
        child: descriptionText);
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
              child: button,
            )
          ],
        ));
  }

  Text _descriptionProgressText() {
    return Text(
      "Процесс выполняется...",
      style: TextStyle(fontSize: 16),
    );
  }

  Text _descriptionFinishedText() {
    return Text(
      "Процесс успешно выполнен",
      style: TextStyle(fontSize: 16),
    );
  }

  ElevatedButton _finishedButton(String recordName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, Routes.chart, ModalRoute.withName(Routes.home), arguments: {"record-name": recordName});
      },
      child: Text("Перейти к графику"),
    );
  }
  ElevatedButton _progressButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
      onPressed: () {
        print('stop button pressed');
        MeasuringEvent event = MeasuringStopEvent(
            topic: Topic.gauss.toShortString());
        BlocProvider.of<MeasuringBloc>(context).add(event);
        Navigator.pop(context);
      },
      child: Text("Остановить"),
    );
  }
}
