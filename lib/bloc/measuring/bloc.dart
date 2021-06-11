import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/measuring/events.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:coercive_force_meter/models/message.dart';
import 'package:coercive_force_meter/wifi_connection/message_protocol.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class MeasuringBloc extends Bloc<MeasuringEvent, MeasuringState> {
  MeasuringBloc(MeasuringState initialState) : super(initialState);
  PhoneSocket socket;

  @override
  Stream<MeasuringState> mapEventToState(event) async* {
    if (socket == null) {
      socket = PhoneSocket();
    }
    if (event is MeasuringStartEvent) {
      socket.sendMessage(topic: event.topic, message: event.message);
      while (socket.messagesReceived != GaussPointsAmount) {
        Message message = await socket.getMessage(socket.messagesReceived + 1);
        print(socket.messagesReceived);
        //todo: save datapoints somewhere
        yield MeasuringReceivedMessageState(socket.messagesReceived);
      }
      yield MeasuringFinishedState();
      socket.messagesReceived = 0;
    }
  }
}
