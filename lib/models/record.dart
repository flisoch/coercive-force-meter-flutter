import 'package:coercive_force_meter/models/data.dart';
import 'package:coercive_force_meter/models/message.dart';

class Record extends Data {
  String sampleName;
  List<Message> measurements;
  DateTime recordDateTime;
}
