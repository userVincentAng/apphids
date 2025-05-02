class SensorParser {
  static Map<String, dynamic> parseSensorData(String rawData) {
    try {
      // Split the raw data into segments
      final segments = rawData.split('|');

      return {
        'timestamp': DateTime.parse(segments[0]),
        'temperature': double.parse(segments[1]),
        'humidity': double.parse(segments[2]),
        'soilMoisture': double.parse(segments[3]),
        'lightLevel': int.parse(segments[4]),
        'pestActivity': int.parse(segments[5]),
      };
    } catch (e) {
      throw FormatException('Invalid sensor data format: $e');
    }
  }

  static bool isPestActivityHigh(int activityLevel) {
    return activityLevel > 7; // Threshold for high pest activity
  }

  static bool isSoilMoistureOptimal(double moisture) {
    return moisture >= 30 && moisture <= 70; // Optimal range 30-70%
  }

  static String getSoilMoistureStatus(double moisture) {
    if (moisture < 30) return 'Low';
    if (moisture > 70) return 'High';
    return 'Optimal';
  }
}
