import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/mask.dart';
import 'package:coercive_force_meter/models/message.dart';

import 'message_protocol.dart';

class PhoneSocket {
  Map<int, Completer> _completers = {};

  String host = "192.168.1.167";

  // String host = "192.168.1.3";
  int port = 4567;
  Socket _cfmSocket;
  ServerSocket _phoneSocket;
  bool isConnected = false;
  bool error = false;
  bool received = true;
  int messagesReceived = 0;

  void handleConnection(Socket client) {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    _cfmSocket = client;
    _cfmSocket.listen((data) {
      String stringData = new String.fromCharCodes(data);
      Map<String, dynamic> json = jsonDecode(stringData);
      String topicString = json["topic"];
      Topic topic = Topic.from[topicString];
      received = false;
      if (topic == Topic.disconnect) {
        print("Got Request to Disconnect! Disconnecting");
        sendDisconnectionAck();
      } else if (topic == Topic.connect) {
        String data = json["data"];
        if (data == "hello") {
          print("GOT HELLO");
          sendConnectionAck();
        } else if (data == "gack") {
          isConnected = true;
        }
      } else if (topic == Topic.mask) {
        Mask mask = Mask.fromJson(jsonDecode(json["data"]));
        print(mask);
      } else if (topic == Topic.gauss) {
        Map<String, dynamic> messageData = json["data"];
        if (messageData.containsKey("eof")) {
          messagesReceived = 0;
          received = true;
        } else {
          Message message = Message.fromJson(messageData);
          print(message);
          messagesReceived += 1;
          _completers[messagesReceived].complete(jsonEncode(messageData));
        }
      }
    });
  }

  Future<void> start() async {
    ServerSocket.bind(InternetAddress.anyIPv4, 4567)
        .then((ServerSocket socket) {
      _phoneSocket = socket;
      _phoneSocket.listen((client) {
        handleConnection(client);
      });
    });
  }

  void doneHandler() {
    received = true;
    isConnected = false;
    _cfmSocket.destroy();
  }

  Future<String> sendMessage(
      {String method, String topic, String message = ""}) async {
    _completers[1] = Completer<String>();
    Map<String, dynamic> request = {
      "method": method,
      "topic": topic,
      "message": message
    };
    String messageString = jsonEncode(request);
    print("sending message: $messageString \n");
    _cfmSocket.write(messageString);
    _cfmSocket.flush();
    return _completers[1].future;
  }

  void close() {
    print("sending disconnect message \n");
    sendMessage(method: "get", topic: "/disconnect");
    doneHandler();
  }

  Future<String> getMessage(int n) {
    print('AAAAAA $n');
    _completers[n] = Completer<String>();
    return _completers[n].future;
  }

  void sendConnectionAck() {
    Map<String, dynamic> response = {
      "topic": Topic.connect.toShortString(),
      "data": "ack"
    };
    String data = jsonEncode(response);
    _cfmSocket.write(data);
    _cfmSocket.flush();
  }

  void sendDisconnectionAck() {
    Map<String, dynamic> map = {
      "topic": Topic.disconnect.toShortString(),
      "data": "disconnect received. Good bye"
    };
    String data = jsonEncode(map);
    _cfmSocket.write(data);
    _cfmSocket.flush();
    _cfmSocket.destroy();
  }
}
