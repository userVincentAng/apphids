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

  Future<List<ChemigationLevel>> getChemigationLevels() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/chemigation'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChemigationLevel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch chemigation data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chemigation data: $e');
      rethrow;
    }
  }

  Future<ChemigationLevel> postChemigationLevel(ChemigationLevel level) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/chemigation'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(level.toJson()),
      );

      if (response.statusCode == 201) {
        return ChemigationLevel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to post chemigation data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting chemigation data: $e');
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
}
