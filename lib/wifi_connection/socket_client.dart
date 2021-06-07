import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/mask.dart';
import 'package:coercive_force_meter/models/message.dart';

class SocketClient {
  Map<int, Completer> _completers = {};
  static final SocketClient _socketClient = SocketClient._internal();
  SocketClient._internal();
  factory SocketClient() {
    return _socketClient;
  }

  String host = "192.168.1.167";
  // String host = "192.168.1.3";
  int port = 4567;
  Socket _serverSocket;
  bool isConnected = false;
  bool error = false;
  bool received = true;
  int messagesReceived = 0;

  Future<void> connect() async {
    await Socket.connect(host, port).then((Socket socket) {
      isConnected = true;
      _serverSocket = socket;
      _serverSocket.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
    }).catchError((Object e) {
      print("Unable to connect: $e");
      error = true;
    });
  }

  Future<String> getMessage(int n) {
    print('AAAAAA $n');
    _completers[n] = Completer<String>();
    return _completers[n].future;
  }

  Future<String> dataHandler(data) async {
    received = false;
    print(new String.fromCharCodes(data));
    String stringData = new String.fromCharCodes(data);
    Map<String, dynamic> json = jsonDecode(stringData);
    String method = json["method"];
    String topic = json["topic"];
    Map<String, dynamic> messageData = json["data"];

    if (method == "post") {
      if (topic == "/end_of_message") {
        messagesReceived = 0;
        received = true;
      }
      if (topic == "/messages") {
        Message message = Message.fromJson(messageData);
        print(message);
        messagesReceived += 1;
        _completers[messagesReceived].complete(jsonEncode(messageData));
      } else if (topic == "/mask") {
        Mask mask = Mask.fromJson(messageData);
        print(mask);
      } else if (topic == "/disconnect") {
        print(messageData);
      }
    }
  }

  AsyncError errorHandler(err, StackTrace trace) {
    received = true;
    isConnected = false;
    error = true;
    _serverSocket.destroy();
    print(err);
    return err;
  }

  void doneHandler() {
    received = true;
    isConnected = false;
    _serverSocket.destroy();
  }

  void close() {
    print("sending disconnect message \n");
    sendMessage(method: "get", topic: "/disconnect");
    doneHandler();
  }

  void gauss({Mask mask}) {
    Map<String, dynamic> maskMap = mask.toJson();
    String messageString = jsonEncode(maskMap);
    sendMessage(topic: "/gauss", message: messageString);
  }

  Future<String> sendMessage({String method, String topic, String message=""}) async {
    _completers[1] = Completer<String>();
    Map<String, dynamic> request = {
      "method": method,
      "topic": topic,
      "message": message
    };
    String messageString = jsonEncode(request);
    print("sending message: $messageString \n");
    _serverSocket.write(messageString);
    _serverSocket.flush();
    return _completers[1].future;

  }
}
