import 'package:coercive_force_meter/bloc/cfm/bloc.dart';
import 'package:coercive_force_meter/bloc/cfm/events.dart';
import 'package:coercive_force_meter/bloc/cfm/states.dart';
import 'package:coercive_force_meter/ui/measuring_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CfmSwitchingOn extends StatefulWidget {
  const CfmSwitchingOn({Key key}) : super(key: key);

  @override
  _CfmSwitchingOnState createState() => _CfmSwitchingOnState();
}

class _CfmSwitchingOnState extends State<CfmSwitchingOn> {
  int currentIndex = 0;
  final snackBar =
      SnackBar(content: Text('Сначала подключитесь к устройству!'));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CfmBloc, WifiState>(
      builder: (context, state) {
        print(state);
        Color backgroundColor = getBackgroundColor(state);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Center(child: Text("Коэрцитиметр")),
            ),
            body: _body(state, backgroundColor),
            backgroundColor: backgroundColor);
      },
    );
  }

  Color getBackgroundColor(WifiState state) {
    if (state is WifiDisconnectedState) {
      return Colors.blueGrey;
    } else if (state is WifiConnectedState) {
      return Colors.blueAccent;
    } else {
      return Colors.blueGrey;
    }
  }

  Widget _body(WifiState state, Color backgroundColor) {
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
                          state is WifiConnectedState
                              ? "Подключен"
                              : state is WifiConnectingState
                                  ? "Подключаюсь"
                                  : state is WifiDisconnectedState
                                      ? "Не подключен"
                                      : state is WifiConnectionErrorState
                                          ? "Ошибка подключения"
                                          : "Неизвестная ошибка",
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
                        heroTag: 'wifi',
                        onPressed: () {
                          WifiEvent event = state is WifiConnectedState
                              ? WifiDisconnectEvent()
                              : WifiConnectEvent();
                          BlocProvider.of<CfmBloc>(context).add(event);
                        },
                        backgroundColor: backgroundColor,
                        shape: StadiumBorder(
                            side: BorderSide(color: Colors.black, width: 2)),
                        child: Icon(
                          state is WifiConnectedState
                              ? Icons.wifi
                              : Icons.wifi_off,
                          color: Colors.black,
                          size: 32,
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
                        heroTag: 'measuring',
                        onPressed: state is WifiConnectedState
                            ? () {
                                print("Start!");
                                WifiEvent event = WifiStartTransmissionEvent();
                                BlocProvider.of<CfmBloc>(context).add(event);
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => MeasuringScreen(),
                                ));
                              }
                            : () {
                                final snackBar = SnackBar(
                                  content: Text(
                                      'Сначала подключитесь к устройству!'),
                                  action: SnackBarAction(
                                    label: 'Ок',
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                        tooltip: 'Начать сбор данных',
                        backgroundColor: backgroundColor,
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
                          heroTag: 'results',
                          onPressed: () {
                            setState(() {
                              // isConnected = !isConnected;
                            });
                          },
                          foregroundColor: Colors.blueGrey,
                          backgroundColor: backgroundColor,
                          shape: StadiumBorder(
                              side: BorderSide(color: Colors.black, width: 2)),
                          child: Icon(
                            Icons.analytics_rounded,
                            color: Colors.black,
                            size: 32,
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [Text('Графики')],
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
}
