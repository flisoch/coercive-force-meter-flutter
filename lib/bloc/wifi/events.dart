abstract class WifiEvent {}

class WifiConnectEvent extends WifiEvent {}

class WifiDisconnectEvent extends WifiEvent {}

class WifiSendMessageEvent extends WifiEvent {
  String method;
  String topic;
  String message;
  WifiSendMessageEvent({this.method="post", this.topic, this.message});
}

class WifiStartTransmissionEvent extends WifiEvent {}
