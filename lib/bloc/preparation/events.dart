abstract class PreparationEvent {}

class PreparationSendMessageEvent extends PreparationEvent {
  String method;
  String topic;
  String message;
  PreparationSendMessageEvent({this.method="post", this.topic, this.message});
}