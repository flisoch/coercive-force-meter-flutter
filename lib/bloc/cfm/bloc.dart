import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/cfm/events.dart';
import 'package:coercive_force_meter/bloc/cfm/states.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class CfmBloc extends Bloc<WifiEvent, WifiState> {
  SocketClient socket;

  CfmBloc(WifiState initialState) : super(initialState);

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

    if (event is WifiStartTransmissionEvent) {
      socket.getMessages();
      yield WifiRxMeasurementsState();
    }
  }
}
