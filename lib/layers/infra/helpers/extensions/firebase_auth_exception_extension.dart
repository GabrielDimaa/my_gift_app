import 'package:firebase_auth/firebase_auth.dart';

import '../../errors/infra_error.dart';


extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  ExternalError get getExternalError {
    switch(code.toLowerCase()) {
      case "auth/user-not-found":
      case "user-not-found": return NotFoundExternalError();
      case "auth/wrong-password":
      case "wrong-password": return WrongPasswordExternalError();
      case "auth/invalid-email":
      case "invalid-email": return EmailInvalidExternalError();
      case "auth/email-already-in-use":
      case "email-already-in-use": return EmailInUseExternalError();
      case "auth/account-exists-with-different-credential":
      case "account-exists-with-different-credential": return NotFoundExternalError();
      case "auth/invalid-credential":
      case "invalid-credential": return NotFoundExternalError();
      case "auth/invalid-verification-code":
      case "invalid-verification-code": return InvalidActionExternalError();
      case "auth/invalid-action-code":
      case "invalid-action-code": return InvalidActionExternalError();
      case "auth/expired-action-code":
      case "expired-action-code": return InvalidActionExternalError();
      default: return UnexpectedExternalError();
    }
  }
}