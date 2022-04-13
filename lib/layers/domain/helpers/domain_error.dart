abstract class DomainError implements Exception {
  String get message;
}

class UnexpectedError extends DomainError {
  @override
  final String message;
  UnexpectedError(this.message);
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