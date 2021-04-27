import 'package:coercive_force_meter/bloc/measuring/bloc.dart';
import 'package:coercive_force_meter/bloc/measuring/states.dart';
import 'package:coercive_force_meter/models/mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasuringScreen extends StatefulWidget {
  const MeasuringScreen({Key key}) : super(key: key);

  @override
  _MeasuringState createState() => _MeasuringState();
}

class _MeasuringState extends State<MeasuringScreen> {
  String _radioValue = null;
  bool hasMasks = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeasuringBloc, MeasuringState>(
      builder: (context, state) {
        print('Measuring Preparation Screen: $state');
        Color backgroundColor = Colors.blueAccent;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: backgroundColor,
              title: Text("Подготовка измерения"),
            ),
            body: _body(state, backgroundColor),
            backgroundColor: backgroundColor);
      },
    );
  }

  Widget _body(MeasuringState state, Color backgroundColor) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _description(),
          _divider(),
          _maskGenerate(),
          _divider(),
          _maskChoose(),
          _divider(),
          _demagnetize(),
          _divider(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _description() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    "Сгенерируйте новую маску, выберите из имеющихся или проведите размагничивание",
                    style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _maskGenerate() {
    return Row(
      children: [
        Column(
          children: [
            Radio(
              activeColor: Colors.lightBlue,
              value: "mask-generate",
              groupValue: _radioValue,
              onChanged: (String value) {
                setState(() {
                  _radioValue = value;
                });
              },
            )
          ],
        ),
        Column(
          children: [
            Text(
              "Сгенерировать новую маску",
              style: TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
      ],
    );
  }

  Widget _maskChoose() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 16, bottom: 16),
                  child: Text("Выбрать маску:",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ],
        ),
        hasMasks ? _buildMasks() : _buildEmptyMasks()
      ],
    );
  }

  Widget _demagnetize() {
    return Row(
      children: [
        Column(
          children: [
            Radio(
              activeColor: Colors.lightBlue,
              value: "demagnetize",
              groupValue: _radioValue,
              onChanged: (String value) {
                setState(() {
                  _radioValue = value;
                });
              },
            )
          ],
        ),
        Column(
          children: [
            Text("размагничивание",
                style: TextStyle(fontWeight: FontWeight.w600))
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return const Divider(
      height: 10,
      thickness: 2,
      indent: 10,
      endIndent: 10,
    );
  }

  Widget _buildEmptyMasks() {
    return Row(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 35, bottom: 10),
              child: Text("Нет сгенерированных масок"),
            )
          ],
        )
      ],
    );
  }

  Widget _buildMasks() {
    List<Mask> masks = Mask.dummyMasks();
    return Row(
      children: [
        Column(
          children: [
            for (var mask in masks)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    activeColor: Colors.lightBlue,
                    value: mask.name,
                    groupValue: _radioValue,
                    onChanged: (String value) {
                      setState(() {
                        _radioValue = value;
                      });
                    },
                  ),
                  Container(
                    child: Text(mask.name),
                  ),
                ],
              )
          ],
        )
      ],
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 55, top: 355, right: 55),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: _radioValue == null?Colors.black54:Colors.lightBlueAccent),
                onPressed: () => print("button pressed"),
                child: Text("Далее"),
              ),
            )
          ],
        )
    );
  }
}
