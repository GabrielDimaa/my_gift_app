import '../../../../i18n/resources.dart';
import '../../../domain/helpers/errors/domain_error.dart';

abstract class ExternalError implements Exception {
  DomainError toDomainError();
}

class UnexpectedExternalError extends ExternalError {
  final String? message;

  UnexpectedExternalError({this.message});

  @override
  DomainError toDomainError() => UnexpectedDomainError(message ?? R.string.unexpectedError);
}

class ConnectionExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.connectionError);
}

class AbortedExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.abortedError);
}

class CancelledExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.cancelledError);
}

class InternalExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.internalError);
}

class InvalidArgumentExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.invalidArgumentError);
}

class PermissionDeniedExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.permissionDeniedError);
}

class UnauthenticatedExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.unauthenticatedError);
}

class UnavailableExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.unavailableError);
}

class ResourceExhaustedExternalError extends ExternalError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.resourceExhaustedError);
}

class AlreadyExistsExternalError extends ExternalError {
  @override
  DomainError toDomainError() => AlreadyExistsDomainError();
}

class NotFoundExternalError extends ExternalError {
  @override
  DomainError toDomainError() => NotFoundDomainError();
}

class InvalidDataExternalError extends ExternalError {
  @override
  DomainError toDomainError() => ValidationDomainError();
}

//region Auth

class EmailInvalidExternalError extends ExternalError {
  @override
  DomainError toDomainError() => EmailInvalidDomainError();
}

class EmailInUseExternalError extends ExternalError {
  @override
  DomainError toDomainError() => EmailInUseDomainError();
}

class EmailNotVerifiedExternalError extends ExternalError {
  @override
  DomainError toDomainError() => EmailNotVerifiedDomainError();
}

class WrongPasswordExternalError extends ExternalError {
  @override
  DomainError toDomainError() => PasswordDomainError();
}

class InvalidActionExternalError extends ExternalError {
  @override
  DomainError toDomainError() => InvalidActionDomainError();
}
//endregion
