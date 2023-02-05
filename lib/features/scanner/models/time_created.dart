import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:kuleta/utils/time_of_day.dart';

enum TimeCreatedValidationError { future, empty, missingSelectedDate }

class TimeCreated extends FormzInput<TimeOfDay?, TimeCreatedValidationError> {
  const TimeCreated.pure(this.selectedDate) : super.pure(null);

  const TimeCreated.dirty(super.value, this.selectedDate) : super.dirty();

  final DateTime? selectedDate;

  @override
  TimeCreatedValidationError? validator(TimeOfDay? value) {
    if (value == null) {
      return TimeCreatedValidationError.empty;
    } else if (selectedDate == null) {
      return TimeCreatedValidationError.missingSelectedDate;
    }

    if (value.inTheFuture(selectedDate!)) {
      return TimeCreatedValidationError.future;
    }

    return null;
  }
}
