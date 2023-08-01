import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  //main colors
  static const transparent = Colors.transparent;
  static const white = Colors.white;
  static const black = Colors.black;
  static const grey = Colors.grey;
  static const yellow = Colors.yellow;
  static const deepPurple = Colors.deepPurple;
  static const green = Colors.green;


  //every colors
  static const cFF949494 = Color(0xFF949494);

  static const c2432432431 = Color.fromRGBO(243, 243, 243, 1);

  static List<BoxShadow> shadowThree = [
    BoxShadow(
      color: black.withOpacity(0.2),
      blurRadius: 25,
      offset: const Offset(0, 5),
      spreadRadius: 0.5,
    ),
  ];
}
