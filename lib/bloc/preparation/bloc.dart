import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/preparation/events.dart';
import 'package:coercive_force_meter/bloc/preparation/states.dart';
import 'package:coercive_force_meter/wifi_connection/socket_client.dart';

class PreparationBloc extends Bloc<PreparationEvent, PreparationState> {
  PreparationBloc(PreparationState initialState) : super(initialState);
  PhoneSocket socket;

  @override
  Stream<PreparationState> mapEventToState(event) async* {
    if (socket == null) {
      socket = PhoneSocket();
    }
  }
}
