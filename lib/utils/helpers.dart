import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String getDayName(String dayCode) {
    const days = {
      'Senin': 'Senin',
      'Selasa': 'Selasa',
      'Rabu': 'Rabu',
      'Kamis': 'Kamis',
      'Jumat': 'Jumat',
      'Sabtu': 'Sabtu',
      'Minggu': 'Minggu',
    };
    return days[dayCode] ?? dayCode;
  }
}

class GradeUtils {
  static String getPredikatColor(String predikat) {
    switch (predikat) {
      case 'A':
        return '#4CAF50';
      case 'B':
        return '#2196F3';
      case 'C':
        return '#FF9800';
      case 'D':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }

  static String getPredikatLabel(String predikat) {
    switch (predikat) {
      case 'A':
        return 'Sangat Baik';
      case 'B':
        return 'Baik';
      case 'C':
        return 'Cukup';
      case 'D':
        return 'Kurang';
      default:
        return 'Tidak Ada';
    }
  }
}
