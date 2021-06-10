import 'dart:convert';
import 'dart:io';

import 'package:coercive_force_meter/models/mask.dart';
import 'package:coercive_force_meter/models/message.dart';

void main() {
  var qwer = "SDf\0jsdfj\0";

  print(qwer.split('\0'));
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
        if (topic == "/disconnect") {
          Map<String, dynamic> map = {"method": "post", "topic": "/disconnect"};
          map["data"] = "disconnect received. Good bye";
          String data = jsonEncode(map);
          print("Got Request to Disconnect! Disconnecting");
          clientSocket.write(data);
          clientSocket.flush();
          clientSocket.destroy();
        }
      } else if (method == "post") {
        if (topic == "/gauss") {
          print("Got Request to get Messages/DataPoints! \n");
          Mask mask = Mask.fromJson(jsonDecode(json["message"]));
          print(mask);
          int n = 1;
          while (n < 5) {
            sleep(Duration(seconds: 1));
            writeMessage(n++);
          }
          endOfMessage();
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

  void endOfMessage() {
    print("sending End Of Message \n");
    Map<String, dynamic> map = {"method": "post", "topic": "/end_of_message"};
    String data = jsonEncode(map);
    print(data + '\n');
    clientSocket.write(data);
  }
}
