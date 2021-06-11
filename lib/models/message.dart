import 'package:coercive_force_meter/models/data.dart';

class Message extends Data {
  final int n;
  final int t;
  final double H;
  final double Jr;
  final double Ji;

  Message({this.n, this.t, this.Ji, this.Jr, this.H});

  Stream<int> receiveMessage() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x).take(10);
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        n: json['n'] as int,
        t: json['t'] as int,
        Ji: json['Ji'] as double,
        Jr: json['Jr'] as double,
        H: json['H'] as double);
  }

  Map<String, dynamic> toJson() {
    return {'n': n, 't': t, 'Ji': Ji, 'Jr': Jr, 'H': H};
  }

  static List<Message> dummyList() {
    return [];
  }

  static Message fromString(String stringData) {
    var split = stringData.split(" ");
    return Message(
      n: int.parse(split[1]),
      H: double.parse(split[2]),
      Jr: double.parse(split[3]),
      Ji: double.parse(split[4]),
    );
  }
}
