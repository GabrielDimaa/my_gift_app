import 'package:firebase_auth/firebase_auth.dart';

import '../../helpers/errors/infra_error.dart';


extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  InfraError get getInfraError {
    switch(code.toLowerCase()) {
      case "auth/user-not-found":
      case "user-not-found": return NotFoundInfraError();
      case "auth/wrong-password":
      case "wrong-password": return WrongPasswordInfraError();
      case "auth/invalid-email":
      case "invalid-email": return EmailInvalidInfraError();
      case "auth/email-already-in-use":
      case "email-already-in-use": return EmailInUseInfraError();
      case "auth/account-exists-with-different-credential":
      case "account-exists-with-different-credential": return NotFoundInfraError();
      case "auth/invalid-credential":
      case "invalid-credential": return NotFoundInfraError();
      case "auth/invalid-verification-code":
      case "invalid-verification-code": return InvalidActionInfraError();
      case "auth/invalid-action-code":
      case "invalid-action-code": return InvalidActionInfraError();
      case "auth/expired-action-code":
      case "expired-action-code": return InvalidActionInfraError();
      default: return UnexpectedInfraError();
    }
  }
}