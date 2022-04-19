import 'package:desejando_app/layers/external/helpers/extensions/firebase_auth_exception_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/helpers/params/login_params.dart';
import '../../infra/datasources/i_login_datasource.dart';
import '../../infra/models/user_model.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_user_credential_extension.dart';

class FirebaseLoginDataSource implements ILoginDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseLoginDataSource({required this.firebaseAuth});

  @override
  Future<UserModel> authWithEmail(LoginParams params) async {
    try {
      final UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: params.email, password: params.password);
      final UserModel? user = credential.toModel();

      if (user == null) throw NotFoundExternalError();

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      //Exception pois terá uma mensagem mais amigável em infra layer.
      throw Exception();
    }
  }
}