import 'package:coercive_force_meter/models/data.dart';

class Mask extends Data {
  String name;
  String creationDate;
  List<int> mask;

  Mask({this.name, this.mask});

  factory Mask.fromJson(Map<String, dynamic> json) {
    return Mask(
      mask: List<int>.from(json["mask"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "mask": List<dynamic>.from(mask.map((x) => x)),
      };

  static List<Mask> dummyMasks() {
    List<Mask> masks = [
      Mask(name: "Маска #1", mask: [0, 1, -1, 0, 0]),
      Mask(name: "Маска #2", mask: [1, 1, -1, 0, 1])
    ];
    return masks;
  }
}
