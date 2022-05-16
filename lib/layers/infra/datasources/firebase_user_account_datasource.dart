import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/extensions/firebase_auth_exception_extension.dart';
import '../helpers/extensions/firebase_user_credential_extension.dart';
import '../../domain/helpers/params/login_params.dart';
import '../errors/infra_error.dart';
import 'i_user_account_datasource.dart';
import '../models/user_model.dart';

class FirebaseUserAccountDataSource implements IUserAccountDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseUserAccountDataSource({required this.firebaseAuth});

  @override
  Future<UserModel> authWithEmail(LoginParams params) async {
    try {
      final UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: params.email!, password: params.password!);
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
      final UserModel? user = credential.toModel();

      if (user == null) throw Exception();

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}