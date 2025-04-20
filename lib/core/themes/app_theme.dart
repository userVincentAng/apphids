import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.green,
    useMaterial3: true,
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.green[800],
  );
}