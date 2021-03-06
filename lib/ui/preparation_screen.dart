import 'dart:convert';

import 'package:coercive_force_meter/bloc/preparation/bloc.dart';
import 'package:coercive_force_meter/bloc/preparation/states.dart';
import 'package:coercive_force_meter/models/mask.dart';
import 'package:coercive_force_meter/models/measuring_type.dart';
import 'package:coercive_force_meter/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreparationScreen extends StatefulWidget {
  const PreparationScreen({Key key}) : super(key: key);

  @override
  _PreparationState createState() => _PreparationState();
}

class _PreparationState extends State<PreparationScreen> {
  String _radioValue = null;
  bool hasMasks = true;
  Map<String, Mask> _masksMap = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PreparationBloc(PreparationIdleState()),
      child: BlocBuilder<PreparationBloc, PreparationState>(
        builder: (context, state) {
          print('Measuring Preparation Screen: $state');
          Color backgroundColor = Colors.blueAccent;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: backgroundColor,
                title: Text("Подготовка измерения"),
              ),
              body: _body(state, Colors.white, context),
              backgroundColor: Colors.white);
        },
      ),
    );
  }

  Widget _body(PreparationState state, Color backgroundColor, BuildContext context) {
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
          _buttonNext(context)
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
              activeColor: Colors.blueAccent,
              value: MeasuringType.NEW_MASK.toString(),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  padding: const EdgeInsets.only(left: 48, top: 16, bottom: 16),
                  child: Text("Выбрать маску:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              activeColor: Colors.blueAccent,
              value: MeasuringType.DEMAGNETIZE.toString(),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
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
    for (Mask mask in masks) {
      _masksMap[mask.name] = mask;
    }
    return Row(
      children: [
        Column(
          children: [
            for (var mask in masks)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    activeColor: Colors.blueAccent,
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

  Widget _buttonNext(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 55, top: 355, right: 55),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: _radioValue == null
                        ? Colors.black54
                        : Colors.blueAccent),
                onPressed: _radioValue == null
                    ? null
                    : () {
                        if (_radioValue == MeasuringType.DEMAGNETIZE.toString()) {
                          print("push to demagnetization");
                          Navigator.pushNamed(context, Routes.demagnetize);
                        } else if (_radioValue.startsWith("Маска")) {
                          print("push to gauss");
                          var maskMap = _masksMap[_radioValue].toJson();
                          String maskString = jsonEncode(maskMap);
                          Navigator.pushNamed(context, Routes.gauss,
                              arguments: {"type": MeasuringType.GAUSS, "mask":maskString});
                        } else if (_radioValue == MeasuringType.NEW_MASK.toString()) {
                          print("push to mask generation");
                          Navigator.pushNamed(context, Routes.mask_generate);
                        }
                      },
                child: Text("Запуск"),
              ),
            )
          ],
        ));
  }
}
