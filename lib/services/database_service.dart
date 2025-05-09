import 'package:http/http.dart' as http;
import 'dart:convert';
import '../features/data/models/detection_model.dart';
import '../features/data/models/chemigation_model.dart';
import '../features/data/models/moisture_model.dart';
import '../config/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // API endpoint that will handle the database operations
  final String _apiEndpoint =
      'https://apphids-backend-45def3d38669.herokuapp.com/'; // For local development
  // final String _apiEndpoint = 'http://your-server-ip:3000/api'; // For production

  Future<List<DetectionModel>> getDetectionData() async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.pestDetectionEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => DetectionModel.fromJson(json)).toList()
          ..sort((a, b) => b.date.compareTo(a.date)); // Sort by date descending
      } else {
        throw Exception(
            'Failed to fetch detection data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching detection data: $e');
      rethrow;
    }
  }

  Future<ChemigationLevel> getChemigationLevels() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/chemigation'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('No chemigation data available');
        }
        // Sort by date descending and return the latest entry
        final sortedData = data
            .map((json) => ChemigationLevel.fromJson(json))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        return sortedData.first;
      } else {
        throw Exception(
            'Failed to fetch chemigation data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chemigation data: $e');
      rethrow;
    }
  }

  Future<List<ChemigationLevel>> getChemigationHistory() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/chemigation'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          throw Exception('No chemigation data available');
        }
        // Sort by date ascending to show from first to latest
        return data.map((json) => ChemigationLevel.fromJson(json)).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      } else {
        throw Exception(
            'Failed to fetch chemigation history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chemigation history: $e');
      rethrow;
    }
  }

  Future<MoistureLevel> getLatestMoistureLevel() async {
    try {
      final response = await http.get(
        Uri.parse('$_apiEndpoint/moisture'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MoistureLevel.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch moisture data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching moisture data: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSevereAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('https://apphid-detection-api.onrender.com/severe-alerts'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception(
            'Failed to fetch severe alerts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching severe alerts: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDailyDetectionData() async {
    try {
      final detections = await getDetectionData();

      // Group detections by date
      final Map<String, Map<String, dynamic>> dailyTotals = {};

      for (var detection in detections) {
        final dateKey = detection.dateKey;
        if (!dailyTotals.containsKey(dateKey)) {
          dailyTotals[dateKey] = {
            'date': detection.date,
            'totalAphids': 0,
            'status': 'Normal'
          };
        }

        dailyTotals[dateKey]!['totalAphids'] += detection.numberOfAphids;
        dailyTotals[dateKey]!['status'] = DetectionModel.calculateStatus(
            dailyTotals[dateKey]!['totalAphids'] as int);
      }

      // Convert to list and sort by date descending
      final dailyData = dailyTotals.values.toList()
        ..sort(
            (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

      return dailyData;
    } catch (e) {
      print('Error getting daily detection data: $e');
      rethrow;
    }
  }
}
