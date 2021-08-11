import 'package:flutter/material.dart';

class CustomDateUtils {
  static String getTime(DateTime dateTime) {
    final timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    return '${timeOfDay.hourOfPeriod.toString().padLeft(2, '0')}'
        ':'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String getTimePeriod(DateTime dateTime) {
    final timeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    return timeOfDay.period == DayPeriod.am ? 'ص' : 'م';
  }

  static String getDate(DateTime dateTime) {
    String date = '${dateTime.day.toString().padLeft(2, '0')}'
        '/${dateTime.month.toString().padLeft(2, '0')}'
        '/${dateTime.year}';

    DateTime nowWithHour = DateTime.now();
    DateTime nowWithoutHour =
    DateTime(nowWithHour.year, nowWithHour.month, nowWithHour.day);
    DateTime dateTimeWithoutHour =
    DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (dateTimeWithoutHour.difference(nowWithoutHour).inDays == 0) {
      date = 'اليوم $date';
    } else {
      date = '${getWeekDay(dateTime.weekday)} $date';
    }
    return date;
  }

  static String getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '';
    }
  }
}