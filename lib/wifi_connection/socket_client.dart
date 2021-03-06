import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/message.dart';

import 'message_protocol.dart';

class PhoneSocket {
  Map<int, Completer> _completers = {};
  static final PhoneSocket _phoneSocket = PhoneSocket._internal();

  PhoneSocket._internal();

  factory PhoneSocket() {
    return _phoneSocket;
  }

  int port = 4567;
  Socket _cfmSocket;
  ServerSocket _serverSocket;
  bool isConnected = false;
  bool error = false;
  bool received = false;
  int messagesReceived = 0;

  void handleConnection(Socket client) {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    _cfmSocket = client;
    isConnected = true;

    _cfmSocket.listen((data) {
      String stringData = new String.fromCharCodes(data);
      // print(stringData);
      String topicString = stringData[0];
      Topic topic = Topic.from[topicString];
      received = false;
      if (topic == Topic.disconnect) {
        print("Got Request to Disconnect! Disconnecting");
        sendDisconnectionAck();
      } else if (topic == Topic.mask) {
        // Mask mask = Mask.fromJson(jsonDecode(json["data"]));
        // print(mask);
      } else if (topic == Topic.gauss) {
        // Map<String, dynamic> messageData = json["data"];
        String pointCount = stringData.split(" ")[1];
        if (pointCount == "-1") {
          print("Received all points");
          messagesReceived = 0;
          received = true;
          _completers = {};
        } else if (pointCount == "0"){
          print("G TOPIC RECEIVED");
          _completers[0].complete("OK");
        }
        else {
          Message message = Message.fromString(stringData);
          messagesReceived += 1;
          _completers[messagesReceived].complete(message);
        }
      }
    });
  }

  Future<void> start() async {
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4567);
    _serverSocket.listen((socket) {
      handleConnection(socket);
    });

    while(!isConnected) {
      await Future.delayed(Duration(seconds: 1));
    }
  }

  void doneHandler() {
    received = true;
    isConnected = false;
    // _cfmSocket.close();
    _cfmSocket.destroy();
    _serverSocket.close();
  }

  Future<String> sendMessage(
      {String topic, String message = ""}) async {
    _completers[0] = Completer<String>();
    received = false;
    print("sending message: $message \n");
    _cfmSocket.write(topic);
    _cfmSocket.flush();
    return _completers[0].future;
  }

  void close() {
    print("sending disconnect message \n");
    sendMessage(topic: Topic.disconnect.toShortString());
    doneHandler();
  }

  Future<Message> getMessage(int n) {
    _completers[n] = Completer<Message>();
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
