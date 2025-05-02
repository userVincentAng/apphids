import 'package:flutter/material.dart';
import '../../../services/database_service.dart';
import '../models/detection_model.dart';

class AphidTableScreen extends StatefulWidget {
  const AphidTableScreen({super.key});

  @override
  State<AphidTableScreen> createState() => _AphidTableScreenState();
}

class _AphidTableScreenState extends State<AphidTableScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<DetectionModel> _detections = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDetectionData();
  }

  Future<void> _loadDetectionData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final detections = await _databaseService.getDetectionData();

      setState(() {
        _detections = detections;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aphid Detection Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDetectionData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Number of Aphids')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: _detections.map((detection) {
                      return DataRow(
                        cells: [
                          DataCell(
                              Text(detection.date.toString().split(' ')[0])),
                          DataCell(Text(detection.numberOfAphids.toString())),
                          DataCell(
                            Text(
                              detection.status,
                              style: TextStyle(
                                color:
                                    detection.status.toLowerCase() == 'detected'
                                        ? Colors.red
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
