import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/helpers/params/login_params.dart';
import '../helpers/errors/infra_error.dart';
import '../helpers/extensions/firebase_auth_exception_extension.dart';
import '../helpers/extensions/firebase_exception_extension.dart';
import '../helpers/extensions/firebase_user_credential_extension.dart';
import '../models/user_model.dart';
import './storage/i_storage_datasource.dart';
import 'constants/collection_reference.dart';
import 'i_user_account_datasource.dart';

class FirebaseUserAccountDataSource implements IUserAccountDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final IStorageDataSource firebaseStorageDataSource;

  FirebaseUserAccountDataSource({
    required this.firebaseAuth,
    required this.firestore,
    required this.firebaseStorageDataSource,
  });

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

      //region FirebaseAuth

      await firebaseAuth.createUserWithEmailAndPassword(email: model.email, password: model.password!);

      User? user = firebaseAuth.currentUser;
      if (user == null) throw Exception();

      await sendVerificationEmail(user.uid);

      //endregion

      final String? photoProfile = model.photo;
      model.photo = null;

      //Cria o usuário no Firestore
      await firestore.collection(constantUsersReference).doc(user.uid).set(model.toJson());

      //Faz upload da foto de perfil
      if (photoProfile != null) {
        try {
          final String imageUrl = await firebaseStorageDataSource.upload("profile/${user.uid}", File(photoProfile));
          await firestore.collection(constantUsersReference).doc(user.uid).update({'photo': imageUrl}); //.set({'photo': imageUrl});
          model.photo = imageUrl;
        } catch (e) {
          //Se tiver um erro ao fazer upload da imagem, não deve estourar error para o usuário.
        }
      }

      return model.clone(id: user.uid);
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on FirebaseException catch (e) {
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
      await firebaseAuth.currentUser!.reload();

      return firebaseAuth.currentUser!.emailVerified;
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<UserModel?> getUserLogged() async {
    try {
      final User? user = firebaseAuth.currentUser;
      if (user == null) return null;

      await user.reload();

      return UserModel(
        id: user.uid,
        name: user.displayName ?? "",
        email: user.email!,
        emailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
