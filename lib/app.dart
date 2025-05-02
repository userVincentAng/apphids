// app.dart
import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/routes.dart';
import 'core/services/storage_service.dart';

class AppHIDS extends StatelessWidget {
  final StorageService storageService;

  const AppHIDS({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppHIDS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
