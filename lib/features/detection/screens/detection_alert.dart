import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../data/screens/apphid_data.dart';

class DetectionAlertScreen extends StatelessWidget {
  const DetectionAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.alertTitle), // Reusable string
      ),
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.warning, size: 64, color: Colors.red),
            const Text('Aphids detected!', style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () => _showDetails(context),
              child: const Text('Show Detection Result'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AphidTableScreen(), // Next screen
        ));
  }
}
