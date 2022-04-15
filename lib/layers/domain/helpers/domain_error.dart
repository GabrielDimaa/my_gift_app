import '../../../i18n/resources.dart';

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
