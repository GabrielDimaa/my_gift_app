import '../i18n/resources.dart';

abstract class Error implements Exception {
  String? message;

  Error([this.message]);

  @override
  String toString() => message ?? "";
}

class StandardError extends Error {
  StandardError([String? message]) : super(message);
}

class UnexpectedError extends Error {
  UnexpectedError([String? message]) : super(message ?? R.string.unexpectedError);
}

class RequiredError extends Error {
  RequiredError(String message) : super(message);
}

class EmailError extends Error {
  EmailError([String? message]) : super(message);
}
