import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/mask.dart';
import 'package:coercive_force_meter/models/message.dart';

class SocketClient {
  static final SocketClient _socketClient = SocketClient._internal();
  SocketClient._internal();
  factory SocketClient() {
    return _socketClient;
  }

  String host = "192.168.1.167";
  int port = 4567;
  Socket serverSocket;
  bool isConnected = false;
  bool error = false;
  bool received = true;


  Future<void> connect() async {
    await Socket.connect(host, port).then((Socket socket) {
      isConnected = true;
      serverSocket = socket;
      serverSocket.listen(
          dataHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false);
    }).catchError((Object e) {
      print("Unable to connect: $e");
      error = true;
    });
  }

  void getMessages() {
    Map<String, dynamic> request = {"method": "get", "topic": "/messages"};
    String messageString = jsonEncode(request);
    serverSocket.write(messageString);
    serverSocket.flush();
  }

  void dataHandler(data) {
    received = false;
    print(new String.fromCharCodes(data));
    String stringData = new String.fromCharCodes(data);
    Map<String, dynamic> json = jsonDecode(stringData);
    String method = json["method"];
    String topic = json["topic"];
    Map<String, dynamic> messageData = json["data"];

    if (method == "post") {
      if (topic == "/end_of_message") {
        received = true;
      }
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
    received = true;
    isConnected = false;
    serverSocket.destroy();
  }

  void close() {
    Map<String, dynamic> request = {"method": "get", "topic": "/disconnect"};
    String messageString = jsonEncode(request);
    print("sending disconnect message: $messageString \n");
    serverSocket.write(messageString);
    serverSocket.flush();
    doneHandler();
  }
}
