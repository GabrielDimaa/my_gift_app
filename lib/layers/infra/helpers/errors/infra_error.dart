import '../../../../i18n/resources.dart';
import '../../../domain/helpers/errors/domain_error.dart';

abstract class InfraError implements Exception {
  DomainError toDomainError();
}

class UnexpectedInfraError extends InfraError {
  final String? message;

  UnexpectedInfraError({this.message});

  @override
  DomainError toDomainError() => UnexpectedDomainError(message ?? R.string.unexpectedError);
}

class ConnectionInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.connectionError);
}

class AbortedInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.abortedError);
}

class CancelledInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.cancelledError);
}

class InternalInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.internalError);
}

class InvalidArgumentInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.invalidArgumentError);
}

class PermissionDeniedInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.permissionDeniedError);
}

class UnauthenticatedInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.unauthenticatedError);
}

class UnavailableInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.unavailableError);
}

class ResourceExhaustedInfraError extends InfraError {
  @override
  DomainError toDomainError() => UnexpectedDomainError(R.string.resourceExhaustedError);
}

class AlreadyExistsInfraError extends InfraError {
  @override
  DomainError toDomainError() => AlreadyExistsDomainError();
}

class NotFoundInfraError extends InfraError {
  @override
  DomainError toDomainError() => NotFoundDomainError();
}

class InvalidDataInfraError extends InfraError {
  @override
  DomainError toDomainError() => ValidationDomainError();
}

class WithoutPermissionInfraError extends InfraError {
  @override
  DomainError toDomainError() => WithoutPermissionDomainError();
}

//region Auth

class EmailInvalidInfraError extends InfraError {
  @override
  DomainError toDomainError() => EmailInvalidDomainError();
}

class EmailInUseInfraError extends InfraError {
  @override
  DomainError toDomainError() => EmailInUseDomainError();
}

class EmailNotVerifiedInfraError extends InfraError {
  @override
  DomainError toDomainError() => EmailNotVerifiedDomainError();
}

class WrongPasswordInfraError extends InfraError {
  @override
  DomainError toDomainError() => PasswordDomainError();
}

class InvalidActionInfraError extends InfraError {
  @override
  DomainError toDomainError() => InvalidActionDomainError();
}
//endregion
