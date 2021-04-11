import 'package:coercive_force_meter/models/data.dart';

class Mask extends Data {
  List<int> mask;

  Mask({this.mask});

  factory Mask.fromJson(Map<String, dynamic> json) {
    return Mask(
      mask: List<int>.from(json["mask"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "ints": List<dynamic>.from(mask.map((x) => x)),
      };
}
