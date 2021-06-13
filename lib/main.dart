import 'package:coercive_force_meter/ui/chart_screen.dart';
import 'package:coercive_force_meter/ui/charts_screen.dart';
import 'package:coercive_force_meter/ui/home_screen.dart';
import 'package:coercive_force_meter/ui/preparation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/wifi/bloc.dart';
import 'bloc/wifi/states.dart';
import 'routes.dart';
import 'ui/measuring_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      print("Error initializing firebase");
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      print("Initializing firebase...");
    }
    return BlocProvider(
      create: (BuildContext context) => WiFiBloc(WifiDisconnectedState()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Coercive Force Meter",
          theme: new ThemeData(primarySwatch: Colors.indigo),
          routes: {
            Routes.home: (context) => CfmSwitchingOn(),
            Routes.measure_preparation: (context) => PreparationScreen(),
            Routes.gauss: (context) =>
                MeasuringScreen(ModalRoute.of(context).settings.arguments),
            Routes.charts: (context) => ChartsScreen(),
            Routes.chart: (context) =>
                ChartScreen(ModalRoute.of(context).settings.arguments)
          }),
    );
  }
}
