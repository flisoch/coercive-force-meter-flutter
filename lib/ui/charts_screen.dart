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
  Color selectedColor = Colors.black12;
  List<bool> selectedItems = [];
  AppBar _appBar;
  bool anySelected = false;

  _ChartsState();

  @override
  void initState() {
    super.initState();
    getRecords();
    _appBar = _defaultAppBar();
  }

  void getRecords() async {
    FileStorage fileStorage = FileStorage();
    await fileStorage.init();
    List<String> recordNames = await fileStorage.getRecordNames();
    setState(() {
      this.recordNames = recordNames;
      recordNames.forEach((element) {
        this.selectedItems.add(false);
      });
    });
  }

  AppBar _defaultAppBar() {
    return AppBar(
      title: Text("Графики измерений"),
      backgroundColor: backgroundColor,
    );
  }

  AppBar _selectBar() {
    int selectedCount =
        selectedItems.where((element) => element).toList().length;
    return AppBar(
      title: Text(selectedCount.toString()),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectedItems = selectedItems.map((e) => false).toList();
            _appBar = _defaultAppBar();
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            print("Edit pressed");
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            List<String> deleteNames = [];
            for (var i = 0; i < selectedItems.length; i++) {
              if (selectedItems[i]) {
                deleteNames.add(recordNames[i]);
              }
            }
            removeItems(deleteNames);
          },
        ),
        Icon(Icons.more_vert)
      ],
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (recordNames == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: _appBar,
        body: ListView.builder(
          itemCount: recordNames.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('${recordNames[index].toString()}'),
              selected: selectedItems[index],
              selectedTileColor: selectedColor,
              onLongPress: () {
                setState(() {
                  if (selectedItems[index]) {
                    selectedItems[index] = false;
                  } else {
                    selectedItems[index] = true;
                  }
                  int selectedCount =
                      selectedItems.where((element) => element).toList().length;
                  print(selectedCount);
                  _appBar = selectedCount > 0 ? _selectBar() : _defaultAppBar();
                });
              },
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

  void removeItems(List<String> deleteNames) async {
    FileStorage fileStorage = FileStorage();
    await fileStorage.init();

    deleteNames.forEach((element) {
      fileStorage.removeFile('$element.txt');
      recordNames.remove(element);
    });
    setState(() {
      selectedItems = recordNames.map((e) => false).toList();
      _appBar = _defaultAppBar();
    });
  }
}
