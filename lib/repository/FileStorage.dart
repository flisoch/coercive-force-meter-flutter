import 'dart:io';

import 'package:coercive_force_meter/models/message.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';

class FileStorage {
  File file;

  static final FileStorage _fileStorage = FileStorage._internal();

  FileStorage._internal();

  factory FileStorage() {
    return _fileStorage;
  }

  Future<File> openFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeMessage(Message message, String fileName) async {
    // todo: if file is opened, store in var and don't await again
    if (!file.path.contains(fileName)) {
      file = await openFile(fileName);
    }

    print("WRITE FILE PATH");
    print(file.path);
    String messageString = message.toString();
    return file.writeAsString('$messageString\n', mode: FileMode.append);
  }

  Future<List<Message>> readMessages(String fileName) async {
    if (file.path != fileName) {
      file = await openFile('$fileName');
    }
    var lines = await file.readAsLines();
    print("READ FILE COUNT");
    print(lines.length);
    List<Message> messages = [];
    lines.forEach((element) {
      messages.add(Message.fromFileString(element));
    });
    return messages;
  }

  Future<void> init() async {
    if (file == null) {
      final data = await rootBundle.load('assets/files/gem.txt');
      var localFile = await openFile("gem.txt");
      file = await localFile.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    }
    print(file.path);
  }

  Future<File> writeToFile(ByteData data, String path) {
    return File(path).writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));
  }

  Future<List<String>> getRecordNames() async {
    final directory = await getApplicationDocumentsDirectory();
    var allFiles = await Directory(directory.path).listSync();
    var filtered = allFiles
        .where((element) => element.toString().contains(".txt"))
        .map((e) {
          var lastSeparator = e.path.lastIndexOf(Platform.pathSeparator);
          var substring = e.path.substring(lastSeparator + 1, e.path.length);
          print(substring);
          return substring;
        })
        .toList();
    return filtered;
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
}
