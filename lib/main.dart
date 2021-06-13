import 'package:coercive_force_meter/ui/chart_screen.dart';
import 'package:coercive_force_meter/ui/charts_screen.dart';
import 'package:coercive_force_meter/ui/home_screen.dart';
import 'package:coercive_force_meter/ui/preparation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/wifi/bloc.dart';
import 'bloc/wifi/states.dart';
import 'routes.dart';
import 'ui/measuring_screen.dart';

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
          routes: {
            Routes.home: (context) => CfmSwitchingOn(),
            Routes.measure_preparation: (context) => PreparationScreen(),
            Routes.gauss: (context) => MeasuringScreen(ModalRoute.of(context).settings.arguments),
            Routes.charts: (context) => ChartsScreen(),
            Routes.chart: (context) => ChartScreen(ModalRoute.of(context).settings.arguments)
          }),
    );
  }
}
