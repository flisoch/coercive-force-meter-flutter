import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CfmSwitchingOn extends StatefulWidget {
  @override
  _CfmSwitchingOnState createState() => _CfmSwitchingOnState();
}

class _CfmSwitchingOnState extends State<CfmSwitchingOn> {
  bool isConnected = false;
  int currentIndex = 0;
  final snackBar = SnackBar(content: Text('Сначала подключитесь к устройству!'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isConnected ? Colors.blueAccent : Colors.blueGrey,
          title: Center(child: Text("Коэрцитиметр")),
        ),
        body: _body(),
        bottomNavigationBar: _bottomNavigationBar(),
        backgroundColor: isConnected ? Colors.blueAccent : Colors.blueGrey);
  }

  Widget _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // Icon(Icons.widgets, size: 100,)
                      Image(
                          image: AssetImage('assets/images/Magnet.png'),
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Text(
                          isConnected ? "Подключен" : "Не подключен",
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            isConnected = !isConnected;
                          });
                        },
                        backgroundColor:
                            isConnected ? Colors.blueAccent : Colors.blueGrey,
                        shape: StadiumBorder(
                            side: BorderSide(color: Colors.black, width: 2)),
                        child: Image.asset(
                          'assets/images/pwer.png',
                          height: 45,
                          width: 45,
                          // fit: BoxFit.fill
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [Text('Вкл/Выкл')],
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: isConnected
                            ? () {
                                print("Start!");
                              }
                            : () {
                          final snackBar = SnackBar(
                            content: Text('Сначала подключитесь к устройству!'),
                            action: SnackBarAction(
                              label: 'Ок',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        tooltip: 'Начать сбор данных',
                        backgroundColor:
                            isConnected ? Colors.blueAccent : Colors.blueGrey,
                        shape: StadiumBorder(
                            side: BorderSide(color: Colors.black, width: 2)),
                        autofocus: false,
                        child: Image.asset(
                          'assets/images/play.png',
                          height: 45,
                          width: 45,
                          // fit: BoxFit.fill
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [Text('Начать')],
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            isConnected = !isConnected;
                          });
                        },
                        foregroundColor: Colors.blueGrey,
                        backgroundColor:
                            isConnected ? Colors.blueAccent : Colors.blueGrey,
                        shape: StadiumBorder(
                            side: BorderSide(color: Colors.black, width: 2)),
                        child: Image.asset(
                          'assets/images/filter-mask.png',
                          height: 45,
                          width: 45,
                          // fit: BoxFit.fill
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [Text('Маска')],
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedFontSize: 16,
      selectedItemColor: isConnected ? Colors.black : Colors.indigo,
      backgroundColor: isConnected ? Colors.blueAccent : Colors.blueGrey,
      onTap: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: "home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "statistics",
          icon: Icon(Icons.analytics_rounded),
        ),
        BottomNavigationBarItem(
          label: "asdf",
          icon: Icon(Icons.settings),
        )
      ],
    );
  }
}
