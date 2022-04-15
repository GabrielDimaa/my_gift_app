abstract class DomainError implements Exception {
  String get message;
}

class UnexpectedDomainError extends DomainError {
  @override
  final String message;
  UnexpectedDomainError(this.message);
}

class NotFoundError extends DomainError {
  @override
  final String message;
  NotFoundError(this.message);
}

class AlreadyExistsError extends DomainError {
  @override
  final String message;
  AlreadyExistsError(this.message);
}