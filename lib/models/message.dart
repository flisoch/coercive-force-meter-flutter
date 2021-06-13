import 'package:coercive_force_meter/models/data.dart';

class Message extends Data {
  final int n;
  final int t;
  final double H;
  final double Jr;
  final double Ji;

  Message({this.n, this.t, this.Ji, this.Jr, this.H});

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

  static Message fromFileString(String line) {
    var split = line.split(" ");

    var length = split.length;
    double H;
    double Jr;
    double Ji;
    for (var i = 0; i < length; i++) {
      if (split[i] == '') {
        continue;
      } else {
        if (H == null) {
          H = double.parse(split[i]);
        } else if (Jr == null) {
          Jr = double.parse(split[i]);
        } else if (Ji == null) {
          Ji = double.parse(split[i]);
        }
      }
    }
    return Message(
      H: H,
      Jr: Jr,
      Ji: Ji,
    );
  }

  static Message fromString(String stringData) {
    var split = stringData.substring(4).split(" ");
    var length = split.length;
    double H;
    double Jr;
    double Ji;
    for (var i = 0; i < length; i++) {
      if (split[i] == " ") {
        continue;
      } else {
        if (H == null) {
          H = double.parse(split[i]);
        } else if (Jr == null) {
          Jr = double.parse(split[i]);
        } else if (Ji == null) {
          Ji = double.parse(split[i]);
        }
      }
    }

    return Message(
      H: H,
      Jr: Jr,
      Ji: Ji,
    );
  }

  @override
  String toString() {
    String messageString = "";
    messageString += H.toString() + " " + Jr.toString() + " "+ Ji.toString();
    return messageString;
  }
}
