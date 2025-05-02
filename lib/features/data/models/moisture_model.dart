import 'package:intl/intl.dart';

class MoistureLevel {
  final DateTime date;
  final int level;

  MoistureLevel({
    required this.date,
    required this.level,
  });

  factory MoistureLevel.fromJson(Map<String, dynamic> json) {
    // Combine date and time fields
    final dateTimeString = "${json['date']} ${json['time']}";
    return MoistureLevel(
      date: DateTime.parse(dateTimeString),
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'time': DateFormat('HH:mm:ss').format(date),
      'level': level,
    };
  }
}
