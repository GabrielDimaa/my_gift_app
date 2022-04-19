import 'package:firebase_auth/firebase_auth.dart';

import '../errors/external_error.dart';

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  ExternalError get getExternalError {
    switch(code.toUpperCase()) {
      case "ERROR_INVALID_EMAIL": return EmailInvalidExternalError();
      case "ERROR_INVALID": return EmailInvalidExternalError();
      case "ERROR_EMAIL_ALREADY_IN_USE": return EmailInUseExternalError();
      case "ERROR_INVALID_CREDENTIAL": return AlreadyExistsExternalError();
      case "ERROR_USER_NOT_FOUND": return NotFoundExternalError();
      case "ERROR_WRONG_PASSWORD": return WrongPasswordExternalError();
      case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL": return NotFoundExternalError();
      case "ERROR_INVALID_ACTION_CODE": return ExpiredActionExternalError();
      case "INVALID_ACTION_CODE": return ExpiredActionExternalError();
      case "EXPIRED_ACTION_CODE": return ExpiredActionExternalError();
      case "USER_NOT_FOUND": return NotFoundExternalError();
      case "ERROR_INVALID_VERIFICATION_CODE": return AlreadyExistsExternalError();
      default: return UnexpectedExternalError();
    }
  }
}