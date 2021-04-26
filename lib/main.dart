import 'package:coercive_force_meter/ui/cfm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/wifi/bloc.dart';
import 'bloc/wifi/states.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WiFiBloc(WifiDisconnectedState()),
      child: MaterialApp(
        title: "Coercive Force Meter",
        theme: new ThemeData(primarySwatch: Colors.indigo),
        home: CfmSwitchingOn(),
        ),
    );
  }
}
