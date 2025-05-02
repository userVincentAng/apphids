// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:apphids/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apphids/core/services/storage_service.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Initialize shared preferences for testing
    SharedPreferences.setMockInitialValues({});
    final storageService = StorageService();
    await storageService.init();

    // Build our app and trigger a frame
    await tester.pumpWidget(AppHIDS(storageService: storageService));

    // Verify that the app title is present
    expect(find.text('AppHIDS'), findsOneWidget);
  });
}
