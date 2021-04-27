import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/wifi/events.dart';
import 'package:coercive_force_meter/bloc/wifi/states.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class WiFiBloc extends Bloc<WifiEvent, WifiState> {
  SocketClient socket;

  WiFiBloc(WifiState initialState) : super(initialState);

  @override
  Stream<WifiState> mapEventToState(WifiEvent event) async* {
    if (event is WifiConnectEvent) {
      socket = SocketClient();
      yield WifiConnectingState();

      await socket.connect();
      if (socket.isConnected) {
        yield WifiConnectedState();
      }
      if (socket.error) {
        yield WifiConnectionErrorState();
      }
    }
    if (event is WifiDisconnectEvent) {
      if (socket != null) {
        socket.close();
      }
      yield WifiDisconnectedState();
    }

    if (event is WifiSendMessageEvent) {
      socket.sendMessage(
          method: event.method, topic: event.topic, message: event.message);
      yield WifiRxMeasurementsState();
    }
    if (socket.received && socket.isConnected) {
      yield WifiConnectedState();
    }
  }
}
