import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/domain/helpers/params/new_password_params.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/helpers/params/login_params.dart';
import '../../helpers/connectivity_network.dart';
import '../../helpers/errors/infra_error.dart';
import '../../helpers/extensions/firebase_auth_exception_extension.dart';
import '../../helpers/extensions/firebase_exception_extension.dart';
import '../../models/user_model.dart';
import 'constants/collection_reference.dart';
import '../i_user_account_datasource.dart';
import 'storage/i_storage_datasource.dart';

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
      await ConnectivityNetwork.hasInternet();

      final UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: params.email, password: params.password);

      if (credential.user == null) throw NotFoundInfraError();

      final snapshotUser = await firestore.collection(constantUsersReference).where(FieldPath.documentId, isEqualTo: credential.user!.uid).get();
      final Map<String, dynamic> jsonUser = snapshotUser.docs.first.data()..addAll({'id': credential.user!.uid});

      final UserModel userModel = UserModel.fromJson(jsonUser);
      userModel.emailVerified = credential.user!.emailVerified;

      return userModel;
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
      await ConnectivityNetwork.hasInternet();

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
      var json = model.toJson();
      json.addAll({'searchName': _mountSearchName(model.name)});
      await firestore.collection(constantUsersReference).doc(user.uid).set(json);

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
      await ConnectivityNetwork.hasInternet();

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
      await ConnectivityNetwork.hasInternet();

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
      await ConnectivityNetwork.hasInternet();

      final User? user = firebaseAuth.currentUser;
      if (user == null) return null;

      await user.reload();

      final snapshotUser = await firestore.collection(constantUsersReference).where(FieldPath.documentId, isEqualTo: user.uid).get();
      final Map<String, dynamic> jsonUser = snapshotUser.docs.first.data()..addAll({'id': user.uid});

      final UserModel userModel = UserModel.fromJson(jsonUser);
      userModel.emailVerified = user.emailVerified;

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<UserModel> getById(String userId) async {
    try {
      await ConnectivityNetwork.hasInternet();

      final snapshotUser = await firestore.collection(constantUsersReference).where(FieldPath.documentId, isEqualTo: userId).get();
      final Map<String, dynamic> jsonUser = snapshotUser.docs.first.data();

      if (jsonUser.isEmpty) throw NotFoundInfraError();

      return UserModel.fromJson(jsonUser..addAll({'id': userId}));
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (firebaseAuth.currentUser == null) return;

      await firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> updateUserAccount(UserModel model) async {
    try {
      await ConnectivityNetwork.hasInternet();

      final WriteBatch batch = firestore.batch();

      if (model.photo?.isNotEmpty ?? false) {
        if (!(Uri.tryParse(model.photo!)?.isAbsolute ?? false)) {
          final snapshot = await firestore.collection(constantUsersReference).doc(model.id).get();
          if ((snapshot.data()?['photo'] ?? false) != null) {
            await firebaseStorageDataSource.delete("profile/${model.id}");
          }

          final String photoUrl = await firebaseStorageDataSource.upload("profile/${model.id}", File(model.photo!));
          model.photo = photoUrl;
        }
      }

      batch.update(firestore.collection(constantUsersReference).doc(model.id), model.toJson());

      await batch.commit();
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> sendCodeUpdatePassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> updatePassword(NewPasswordParams params) async {
    try {
      await firebaseAuth.confirmPasswordReset(code: params.code, newPassword: params.newPassword);
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  List<String> _mountSearchName(String name) {
    List<String> list = [];
    for (var index = 0; index <= name.length; index++) {
      list.add(name.substring(0, index).toLowerCase());
    }
    return list;
  }
}
