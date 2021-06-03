import 'package:coercive_force_meter/models/data.dart';
import 'package:coercive_force_meter/models/message.dart';

class Record extends Data {
  String sampleName;
  List<Message> measurements;
  DateTime recordDateTime;

  Record({this.sampleName, this.measurements, this.recordDateTime});

  static List<Record> dummyList() {
    Record r1 = Record(sampleName: "Pesok 20-11-11", recordDateTime: DateTime(2021, 11, 11), measurements: Message.dummyList());
    Record r2 = Record(sampleName: "peschannik 20-01-09", recordDateTime: DateTime(2021, 1, 9), measurements: Message.dummyList());
    Record r3 = Record(sampleName: "Ugol 21-05-04", recordDateTime: DateTime(2021, 5, 4), measurements: Message.dummyList());
    List<Record> records = List.from([r1, r2, r3]);
    return records;
  }
}
