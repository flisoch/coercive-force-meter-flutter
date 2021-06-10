import 'dart:io';

import 'package:coercive_force_meter/bloc/measuring/events.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class MeasuringBloc extends Bloc<MeasuringEvent, MeasuringState> {
  MeasuringBloc(MeasuringState initialState) : super(initialState);
  PhoneSocket socket;
  int N = 4;

  @override
  Stream<MeasuringState> mapEventToState(event) async* {
    if (socket == null) {
      socket = PhoneSocket();
    }
    if (event is MeasuringStartEvent) {
      socket.sendMessage(
          topic: event.topic, message: event.message);
      while (socket.messagesReceived != N) {
        String message = await socket.getMessage(socket.messagesReceived + 1);
        print(socket.messagesReceived);
        yield MeasuringReceivedMessageState(socket.messagesReceived);
        print("adfdf  " + message);
      }

      sleep(Duration(milliseconds: 500));
      print(socket.received);
      if (socket.messagesReceived == 0) {
        yield MeasuringFinishedState();
      }
      socket.messagesReceived = 0;
    }

  }
}
