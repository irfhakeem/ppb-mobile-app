import 'package:flutter/material.dart';

class Helpers {
  static List<String> formatDate(DateTime date) {
    final List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final String month = monthNames[date.month - 1];
    final String day = date.day.toString();
    final String year = date.year.toString();

    return [day, month, year];
  }

  static String formatTime(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
