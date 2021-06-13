
import 'package:coercive_force_meter/repository/FileStorage.dart';
import 'package:coercive_force_meter/routes.dart';
import 'package:flutter/material.dart';

class ChartsScreen extends StatefulWidget {

  ChartsScreen();

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<ChartsScreen> {
  List<String> recordNames;
  Color backgroundColor = Colors.blueAccent;

  _ChartsState();

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  void getRecords() async {
    FileStorage fileStorage = FileStorage();
    await fileStorage.init();
    List<String> recordNames = await fileStorage.getRecordNames();
    setState(() {
      this.recordNames = recordNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (recordNames == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: new AppBar(
          title: new Text('Графики измерений'),
          backgroundColor: backgroundColor,
        ),
        body: ListView.builder(
          itemCount: recordNames.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${recordNames[index].toString()}'),
              onTap: () {
                Navigator.pushNamed(context, Routes.chart,
                    arguments: {"record-name": recordNames[index]});
              },
            );
          },
        ),
      );
    }
  }
}
