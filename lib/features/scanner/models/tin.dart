import 'package:formz/formz.dart';

enum TINValidationError { empty }

class TIN extends FormzInput<String, TINValidationError> {
  const TIN.pure() : super.pure('');

  const TIN.dirty([super.value = '']) : super.dirty();

  @override
  TINValidationError? validator(String value) {
    if (value.isEmpty) {
      return TINValidationError.empty;
    }

    return null;
  }
}
