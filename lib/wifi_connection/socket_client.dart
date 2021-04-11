import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/mask.dart';
import 'package:coercive_force_meter/models/message.dart';

class SocketClient {
  String host = "192.168.1.167";
  int port = 4567;
  Socket serverSocket;

  final String clientAddress;
  final int clientPort;

  SocketClient({this.clientAddress, this.clientPort});

  Future<void> connect() async {
    await Socket.connect(host, port).then((Socket socket) {
      serverSocket = socket;
      serverSocket.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    }).catchError((Object e) {
      print("Unable to connect: $e");
      return e;
    });
  }

  void getMessages() {
    Map<String, dynamic> request = {"method": "get", "topic": "/messages"};
    String messageString = jsonEncode(request);
    serverSocket.write(messageString);
    serverSocket.flush();
  }

  void dataHandler(data) {
    print(new String.fromCharCodes(data));
    String stringData = new String.fromCharCodes(data);
    Map<String, dynamic> json = jsonDecode(stringData);
    String method = json["method"];
    String topic = json["topic"];
    Map<String, dynamic> messageData = json["data"];

    if (method == "post") {
      if (topic == "/messages") {
        Message message = Message.fromJson(messageData);
        print(message);
      } else if (topic == "/mask") {
        Mask mask = Mask.fromJson(messageData);
        print(mask);
      } else if (topic == "/disconnect") {
        print(messageData);
      }
    }
  }

  AsyncError errorHandler(error, StackTrace trace) {
    print(error);
    return error;
  }

  void doneHandler() {
    serverSocket.destroy();
  }

  void close() {
    Map<String, dynamic> request = {"method": "get", "topic": "/disconnect"};
    String messageString = jsonEncode(request);
    print("sending disconnect message: $messageString \n");
    serverSocket.write(messageString);
    serverSocket.flush();
    // doneHandler();
  }
}
