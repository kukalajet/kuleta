import 'package:formz/formz.dart';
import 'package:kuleta/utils/date_time.dart';

enum DateCreatedValidationError { future, empty }

class DateCreated extends FormzInput<DateTime?, DateCreatedValidationError> {
  const DateCreated.pure() : super.pure(null);

  const DateCreated.dirty(DateTime super.value) : super.dirty();

  @override
  DateCreatedValidationError? validator(DateTime? value) {
    if (value == null) {
      return DateCreatedValidationError.empty;
    }
    if (value.inTheFuture()) {
      return DateCreatedValidationError.future;
    }

    return null;
  }
}
