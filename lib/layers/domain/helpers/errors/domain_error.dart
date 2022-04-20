import '../../../../i18n/resources.dart';

abstract class DomainError implements Exception {
  String get message;
}

class UnexpectedDomainError extends DomainError {
  @override
  final String message;

  UnexpectedDomainError(this.message);
}

class AlreadyExistsDomainError extends DomainError {
  @override
  final String message;

  AlreadyExistsDomainError({String? message}) : message = message ?? R.string.alreadyExistsError;
}

class NotFoundDomainError extends DomainError {
  @override
  final String message;

  NotFoundDomainError({String? message}) : message = message ?? R.string.notFoundError;
}

//region Auth
class EmailInUseDomainError extends DomainError {
  @override
  final String message;

  EmailInUseDomainError() : message = R.string.emailInUseError;
}

class EmailNotVerifiedDomainError extends DomainError {
  @override
  final String message;

  EmailNotVerifiedDomainError() : message = R.string.emailNotVerifiedError;
}

class EmailInvalidDomainError extends DomainError {
  @override
  final String message;

  EmailInvalidDomainError() : message = R.string.emailInvalidError;
}

class PasswordDomainError extends DomainError {
  @override
  final String message;

  PasswordDomainError({String? message}) : message = message ?? R.string.passwordError;
}

class InvalidActionDomainError extends DomainError {
  @override
  final String message;

  InvalidActionDomainError({String? message}) : message = message ?? R.string.actionCodeError;
}
//endregion
