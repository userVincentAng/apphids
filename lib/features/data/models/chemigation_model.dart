import 'package:intl/intl.dart';

class ChemigationLevel {
  final DateTime date;
  final int level;

  ChemigationLevel({
    required this.date,
    required this.level,
  });

  factory ChemigationLevel.fromJson(Map<String, dynamic> json) {
    // Combine date and time fields
    final dateTimeString = "${json['date']} ${json['time']}";
    return ChemigationLevel(
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
