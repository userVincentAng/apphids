import 'package:apphids/features/home/screens/dashboard.dart';
import 'package:apphids/features/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';
  static const String dashboard = '/dashboard';
  static const String pestDetection = '/pest-detection';
  static const String irrigation = '/irrigation';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginPage(),
        dashboard: (context) => DashboardPage(),
        // pestDetection: (context) => const DetectionAlertPage(),
        // irrigation: (context) => const IrrigationStatusPage(),
      };
}
