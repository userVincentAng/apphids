// app.dart
import 'package:apphids/features/home/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'features/detection/screens/detection_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP-HIDS',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(), // Initial screen
    );
  }
}