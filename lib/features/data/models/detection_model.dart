class DetectionModel {
  final DateTime date;
  final int numberOfAphids;
  final String status;

  DetectionModel({
    required this.date,
    required this.numberOfAphids,
    required this.status,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    // Combine date and time fields, e.g., "2025-04-30 17:54:10"
    final dateTimeString = "${json['date']} ${json['time']}";
    return DetectionModel(
      date: DateTime.parse(dateTimeString),
      numberOfAphids: json['numberOfAphids'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'numberOfAphids': numberOfAphids,
      'status': status,
    };
  }
}
