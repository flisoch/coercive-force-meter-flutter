import 'package:coercive_force_meter/bloc/cfm/bloc.dart';
import 'package:coercive_force_meter/bloc/cfm/states.dart';
import 'package:coercive_force_meter/ui/cfm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CfmBloc(WifiDisconnectedState()),
      child: MaterialApp(
        title: "Coercive Force Meter",
        theme: new ThemeData(primarySwatch: Colors.indigo),
        home: CfmSwitchingOn(
          bloc: CfmBloc(WifiDisconnectedState()),
        ),
      ),
    );
  }
}
