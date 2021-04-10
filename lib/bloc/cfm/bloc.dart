import 'package:bloc/bloc.dart';
import 'package:coercive_force_meter/bloc/cfm/events.dart';
import 'package:coercive_force_meter/bloc/cfm/states.dart';

class CfmBloc extends Bloc<CfmEvent, CfmState> {
  CfmBloc(CfmState initialState) : super(initialState);

  @override
  Stream<CfmState> mapEventToState(CfmEvent event) async* {
    if (event is CfmConnectWifiEvent) {
      yield CfmConnectedState();
    }
    if (event is CfmDisconnectWifiEvent) {
      yield CfmDisconnectedState();
    }
  }
}
