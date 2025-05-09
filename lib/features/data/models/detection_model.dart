class DetectionModel {
  final DateTime date;
  final int numberOfAphids;
  final String status;

  DetectionModel({
    required this.date,
    required this.numberOfAphids,
    required this.status,
  });

  // Static method to calculate status based on aphid count
  static String calculateStatus(int aphidCount) {
    if (aphidCount <= 15) {
      return 'Normal';
    } else if (aphidCount <= 30) {
      return 'Moderate';
    } else {
      return 'Severe';
    }
  }

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    // Combine date and time fields, e.g., "2025-04-30 17:54:10"
    final dateTimeString = "${json['date']} ${json['time']}";
    final aphidCount = json['numberOfAphids'] as int;
    return DetectionModel(
      date: DateTime.parse(dateTimeString),
      numberOfAphids: aphidCount,
      status: calculateStatus(aphidCount),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'numberOfAphids': numberOfAphids,
      'status': status,
    };
  }

  // Helper method to get date key for grouping
  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
