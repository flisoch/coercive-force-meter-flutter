class Message {
  int n;
  int t;
  double Ji;
  double H;

  Stream<int> receiveMessage() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x).take(10);
  }
}