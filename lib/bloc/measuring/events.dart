abstract class MeasuringEvent {}

class MeasuringStartEvent extends MeasuringEvent {
  String method;
  String topic;
  String message;
  MeasuringStartEvent({this.method="post", this.topic, this.message});
}

class MeasuringStopEvent extends MeasuringEvent {}

class MeasuringReceiveMessageEvent extends MeasuringEvent {}