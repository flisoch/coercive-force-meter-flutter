class MeasuringState {}

class MeasuringMaskChosenState extends MeasuringState {}

class MeasuringIdleState extends MeasuringState {}

class MeasuringStartedState extends MeasuringState {}

class MeasuringFinishedState extends MeasuringState {
  String recordName;
  MeasuringFinishedState(this.recordName);
}

class MeasuringStoppedState extends MeasuringState {}

class MeasuringReceivedMessageState extends MeasuringState {
  int messagesReceived;

  MeasuringReceivedMessageState(this.messagesReceived);
}
