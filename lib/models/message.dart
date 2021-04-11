import 'package:coercive_force_meter/models/data.dart';

class Message extends Data {
  final int n;
  final int t;
  final double Ji;
  final double H;

  Message({this.n, this.t, this.Ji, this.H});

  Stream<int> receiveMessage() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x).take(10);
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        n: json['n'] as int,
        t: json['t'] as int,
        Ji: json['Ji'] as double,
        H: json['H'] as double);
  }

  Map<String, dynamic> toJson() {
    return {'n': n, 't': t, 'Ji': Ji, 'H': H};
  }
}
