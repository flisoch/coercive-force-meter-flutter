abstract class MeasuringEvent {}

class MeasuringStartEvent extends MeasuringEvent {
  String topic;
  String message;
  MeasuringStartEvent({this.topic, this.message});
}

class MeasuringStopEvent extends MeasuringEvent {
  String topic;
  MeasuringStopEvent({this.topic});
}

class MeasuringFinishEvent extends MeasuringEvent {
}

class MeasuringReceiveMessageEvent extends MeasuringEvent {}