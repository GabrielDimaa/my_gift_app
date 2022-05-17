import '../../../../../../i18n/resources.dart';

final String _requiredField = R.string.requiredField;

abstract class IInputValidator {
  String get _message;
  String? validate(String? value);
}

class InputRequiredValidator implements IInputValidator {
  @override
  String get _message => _requiredField;

  @override
  String? validate(String? value) {
    return value == null || value.isEmpty ? _message : null;
  }
}

class InputEmailValidator implements IInputValidator {
  @override
  String get _message => R.string.emailInvalidField;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return _requiredField;

    bool valid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if (!valid) return _message;

    return null;
  }
}

class InputPasswordValidator implements IInputValidator {
  @override
  String get _message => R.string.shortPasswordField;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return _requiredField;
    if (value.length < 8) return _message;

    return null;
  }
}

class InputConfirmPasswordValidator implements IInputValidator {
  final String? password;

  InputConfirmPasswordValidator(this.password);

  @override
  String get _message => R.string.shortPasswordField;

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return _requiredField;
    if (value.length < 8) return _message;
    if (value != password) return R.string.passwordsNotMatchField;

    return null;
  }
}
