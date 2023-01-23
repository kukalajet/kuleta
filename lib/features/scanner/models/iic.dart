import 'package:formz/formz.dart';

enum IICValidationError { empty }

class IIC extends FormzInput<String, IICValidationError> {
  const IIC.pure() : super.pure('');

  const IIC.dirty([super.value = '']) : super.dirty();

  @override
  IICValidationError? validator(String value) {
    if (value.isEmpty) {
      return IICValidationError.empty;
    }

    return null;
  }
}
