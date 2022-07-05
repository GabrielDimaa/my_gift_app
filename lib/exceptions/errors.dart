import '../i18n/resources.dart';

class Error implements Exception {
  final String? message;

  Error([this.message]);

  @override
  String toString() => message?.toString() ?? "";
}

class StandardError implements Error {
  @override
  final String? message;

  StandardError([this.message]);
}

class UnexpectedError implements Error {
  @override
  final String? message;

  UnexpectedError([this.message]) {
    message == null ? R.string.unexpectedError : "";
  }
}

class RequiredError implements Error {
  @override
  final String message;

  RequiredError(this.message);
}

class EmailError implements Error {
  @override
  final String? message;

  EmailError([this.message]);
}
