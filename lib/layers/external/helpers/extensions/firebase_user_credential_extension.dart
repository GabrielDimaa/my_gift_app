import 'package:firebase_auth/firebase_auth.dart';

import '../../../infra/models/user_model.dart';

extension FirebaseUserCredentialException on UserCredential {
  UserModel? toModel() {
    if (user?.uid == null || user?.displayName == null || user?.email == null || user?.phoneNumber == null || user?.emailVerified == null) {
      return null;
    }

    return UserModel(
      id: user!.uid,
      name: user!.displayName!,
      email: user!.email!,
      phone: user!.phoneNumber!,
      photo: user!.photoURL,
      emailVerified: user!.emailVerified,
    );
  }
}
