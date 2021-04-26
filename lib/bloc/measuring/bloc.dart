import 'package:coercive_force_meter/bloc/measuring/events.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:bloc/bloc.dart';

class MeasuringBloc extends Bloc<MeasuringEvent, MeasuringState> {
  MeasuringBloc(MeasuringState initialState) : super(initialState);

  @override
  Stream<MeasuringState> mapEventToState(event) async* {
    if (event is MeasuringStartEvent) {
      yield MeasuringStartedState();
    }
    if (event is MeasuringStopEvent) {
      yield MeasuringStoppedState();
    }
  }
}
