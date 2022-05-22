import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/errors/infra_error.dart';
import '../helpers/extensions/firebase_auth_exception_extension.dart';
import '../helpers/extensions/firebase_user_credential_extension.dart';
import '../../domain/helpers/params/login_params.dart';
import '../helpers/errors/infra_error.dart';
import 'i_user_account_datasource.dart';
import '../models/user_model.dart';

class FirebaseUserAccountDataSource implements IUserAccountDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseUserAccountDataSource({required this.firebaseAuth});

  @override
  Future<UserModel> authWithEmail(LoginParams params) async {
    try {
      final UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: params.email, password: params.password);
      final UserModel? user = credential.toModel();

      if (user == null) throw NotFoundInfraError();

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<UserModel> signUpWithEmail(UserModel model) async {
    try {
      if (model.password == null) throw WrongPasswordInfraError();

      final UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: model.email, password: model.password!);

      User? user = firebaseAuth.currentUser;
      if (user == null) throw Exception();

      await user.updateDisplayName(model.name);
      await sendVerificationEmail(user.uid);

      return model.clone(user.uid);
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> sendVerificationEmail(String userId) async {
    try {
      if (firebaseAuth.currentUser == null) throw Exception();
      await firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<bool> checkEmailVerified(String userId) async {
    try {
      if (firebaseAuth.currentUser == null) throw Exception();
      return firebaseAuth.currentUser!.emailVerified;
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}