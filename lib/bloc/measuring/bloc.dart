import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/measuring/events.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:coercive_force_meter/models/message.dart';
import 'package:coercive_force_meter/models/record.dart';
import 'package:coercive_force_meter/repository/file_storage.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class MeasuringBloc extends Bloc<MeasuringEvent, MeasuringState> {
  MeasuringBloc(MeasuringState initialState) : super(initialState);
  PhoneSocket socket;
  FileStorage fileStorage;


  @override
  Stream<MeasuringState> mapEventToState(event) async* {
    if (socket == null) {
      socket = PhoneSocket();
    }
    if (fileStorage == null) {
      fileStorage = FileStorage();
      fileStorage.init();
    }
    if (event is MeasuringStartEvent) {
      // List<Message> messages = [];
      var dateTime = DateTime.now();
      Record record = Record(sampleName: "Record ${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}", recordDateTime: DateTime.now());
      socket.sendMessage(topic: event.topic, message: event.message);
      while (socket.received != true) {
        Message message = await socket.getMessage(socket.messagesReceived + 1);
        // messages.add(message);
        await fileStorage.writeMessage(message, "${record.sampleName}.txt");
        yield MeasuringReceivedMessageState(socket.messagesReceived);
      }

      yield MeasuringFinishedState();
      socket.messagesReceived = 0;
    }
  }
}
