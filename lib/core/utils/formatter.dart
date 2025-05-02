import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }

  static String formatPercentage(double value) {
    return NumberFormat.percentPattern().format(value / 100);
  }

  static String formatDecimal(double value, {int decimalPlaces = 2}) {
    return NumberFormat.decimalPattern().format(value);
  }
}
