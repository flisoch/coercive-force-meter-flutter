

import 'package:coercive_force_meter/ui/cfm_switching_on.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Coercive Force Meter",
      theme: new ThemeData(primarySwatch: Colors.indigo),
      home: CfmSwitchingOn(),
    );
  }

}

class _homeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("LOADING..."),
      ),
    );
  }

}