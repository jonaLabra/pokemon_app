import 'package:flutter/material.dart';

// GENERATE A CONST TO USE IN A PROJECT

const int pageSize = 20;
final List<Color> backgroundColors = [Colors.blue.shade400, Colors.red.shade300];
const TextStyle pikachuTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w600,
  color: Colors.yellow,
);

bool isLandscape(BuildContext context) =>
    MediaQuery.of(context).orientation == Orientation.landscape;
