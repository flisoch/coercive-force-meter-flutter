import 'package:coercive_force_meter/bloc/preparation/events.dart';
import 'package:coercive_force_meter/bloc/preparation/states.dart';
import 'package:bloc/bloc.dart';

class PreparationBloc extends Bloc<PreparationEvent, PreparationState> {
  PreparationBloc(PreparationState initialState) : super(initialState);

  @override
  Stream<PreparationState> mapEventToState(event) async* {
  }
}
