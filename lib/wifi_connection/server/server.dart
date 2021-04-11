import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/message.dart';

void main() {
  Server server = Server();
  server.start();
}

class Server {
  Socket clientSocket;
  ServerSocket serverSocket;

  void start() {
    ServerSocket.bind(InternetAddress.anyIPv4, 4567)
        .then((ServerSocket socket) {
      serverSocket = socket;
      serverSocket.listen((client) {
        handleConnection(client);
      });
    });
  }

  void handleConnection(Socket client) {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    clientSocket = client;

    clientSocket.listen((data) {
      String stringData = new String.fromCharCodes(data);
      Map<String, dynamic> json = jsonDecode(stringData);
      String method = json["method"];
      String topic = json["topic"];

      if (method == "get") {
        if (topic == "/messages") {
          print("Got Request to get Messages/DataPoints! \n");
          int n = 1;
          while (n < 5) {
            sleep(Duration(seconds: 1));
            writeMessage(n++);
          }
          clientSocket.flush();
        } else if (topic == "/disconnect") {
          Map<String, dynamic> map = {"method": "post", "topic": "/disconnect"};
          map["data"] = {"data": "disconnect received. Good bye"};
          String data = jsonEncode(map);
          print("Got Request to Disconnect! Disconnecting");
          clientSocket.write(data);
          clientSocket.flush();
        }
      }
    });
  }

  void writeMessage(int n) {
    print("sending message #$n !\n");
    Message message = new Message(n: n, t: n * 10, Ji: 1 + 1 / n, H: 2 + 1 / n);
    Map<String, dynamic> map = {"method": "post", "topic": "/messages"};
    map["data"] = message.toJson();
    print(map);
    String data = jsonEncode(map);
    print(data + '\n');
    clientSocket.write(data);
  }
}
