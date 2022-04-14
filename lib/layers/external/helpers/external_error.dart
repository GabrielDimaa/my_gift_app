import '../../../i18n/resources.dart';
import '../../domain/helpers/domain_error.dart';

abstract class ExternalError implements Exception {
  String get message;
  DomainError toDomainError();
}

class ConnectionExternalError extends ExternalError {
  @override
  String message = R.string.semConexao;

  @override
  DomainError toDomainError() => UnexpectedDomainError(message);
}

class UnexpectedExternalError extends ExternalError {
  @override
  String message = R.string.erroInesperado;

  @override
  DomainError toDomainError() => UnexpectedDomainError(message);
}