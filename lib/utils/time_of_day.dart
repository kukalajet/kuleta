import 'package:flutter/material.dart';
import 'package:kuleta/utils/utils.dart';

int calculateDifferenceInHours(DateTime date) {
  final now = DateTime.now();
  return DateTime(date.year, date.month, date.day, date.hour, date.minute)
      .difference(DateTime(now.year, now.month, now.day, now.hour, now.minute))
      .inHours;
}

extension TimeOfDayX on TimeOfDay {
  // bool inTheFuture(DateTime selectedDay) {
  //   final dayWithTime = selectedDay.copyWith(hour: hour, minute: minute);
  //   return dayWithTime.inTheFuture();
  // }
}
