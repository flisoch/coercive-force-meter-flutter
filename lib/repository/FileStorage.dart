import 'dart:io';

import 'package:coercive_force_meter/models/message.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';

class FileStorage {
  File file;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> writeMessage(Message message, String fileName) async {
    // todo: if file is opened, store in var and don't await again
    final file = await _localFile(fileName);
    String messageString = message.toString();
// Write the file
    return file.writeAsString('$messageString');
  }

  Future<List<Message>> readMessages(String fileName) async {
    var lines = await file.readAsLines();
    List<Message> messages = [];
    lines.forEach((element) {
      messages.add(Message.fromFileString(element));
    });
    return messages;
  }

  Future<void> init() async {
    final data = await rootBundle.load('assets/files/gem.txt');
    var localFile = await _localFile("gem.txt");
    file = await localFile.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    print(file.path);
  }

  Future<File> writeToFile(ByteData data, String path) {
    return File(path).writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));
  }
}
