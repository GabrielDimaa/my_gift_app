import 'package:firebase_auth/firebase_auth.dart';

import '../../../../exceptions/errors.dart';
import '../../../../i18n/resources.dart';

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  Error get getInfraError {
    switch(code.toLowerCase()) {
      case "auth/user-not-found":
      case "user-not-found": return StandardError(R.string.notFoundError);
      case "auth/wrong-password":
      case "wrong-password": return StandardError(R.string.passwordError);
      case "auth/invalid-email":
      case "invalid-email": return StandardError(R.string.emailInvalidError);
      case "auth/email-already-in-use":
      case "email-already-in-use": return StandardError(R.string.emailInUseError);
      case "auth/account-exists-with-different-credential":
      case "account-exists-with-different-credential": return StandardError(R.string.notFoundError);
      case "auth/invalid-credential":
      case "invalid-credential": return StandardError(R.string.notFoundError);
      case "auth/invalid-verification-code":
      case "invalid-verification-code":
      case "auth/invalid-action-code":
      case "invalid-action-code":
      case "auth/expired-action-code":
      case "expired-action-code": return StandardError(R.string.actionCodeError);
      default: return UnexpectedError();
    }
  }
}