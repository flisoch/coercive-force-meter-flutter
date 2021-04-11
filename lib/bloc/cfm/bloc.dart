import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/cfm/events.dart';
import 'package:coercive_force_meter/bloc/cfm/states.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class CfmBloc extends Bloc<CfmEvent, CfmState> {
  SocketClient socket;

  CfmBloc(CfmState initialState) : super(initialState);

  @override
  Stream<CfmState> mapEventToState(CfmEvent event) async* {
    if (event is CfmConnectWifiEvent) {
      socket = SocketClient();
      socket.connect();
      yield CfmConnectedState();
    }
    if (event is CfmDisconnectWifiEvent) {
      socket.close();
      yield CfmDisconnectedState();
    }

    if (event is CfmStartTransmissionEvent) {
      socket.getMessages();
      yield CfmReceivingMessages();
    }
  }
}
