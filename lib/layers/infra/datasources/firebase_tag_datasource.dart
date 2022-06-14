import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/extensions/firebase_exception_extension.dart';
import '../models/user_model.dart';
import './constants/collection_reference.dart';
import '../helpers/errors/infra_error.dart';
import 'i_tag_datasource.dart';
import '../models/tag_model.dart';
import 'i_user_account_datasource.dart';

class FirebaseTagDataSource implements ITagDataSource {
  final FirebaseFirestore firestore;
  final IUserAccountDataSource userDataSource;

  FirebaseTagDataSource({required this.firestore, required this.userDataSource});

  @override
  Future<List<TagModel>> getAll(userId) async {
    try {
      //Busca o usuário
      final UserModel user = await userDataSource.getById(userId);
      final Map<String, dynamic> jsonUser = user.toJson()..addAll({'id': user.id});

      final snapshot = await firestore.collection(constantTagsReference).where("user_id", isEqualTo: userId).get();
      final jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) {
          return json;
        }
        return json..addAll({'id': e.id, 'user': jsonUser});
      }).toList();

      List<TagModel> tagsModel = [];

      for (var json in jsonList) {
        if (TagModel.validateJson(json)) {
          tagsModel.add(TagModel.fromJson(json));
        }
      }

      return tagsModel;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<TagModel> create(TagModel model) async {
    try {
      final Map<String, dynamic> json = model.toJson();
      final doc = await firestore.collection(constantTagsReference).add(json);

      return model.clone(id: doc.id);
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<TagModel> update(TagModel model) async {
    try {
      final doc = firestore.collection(constantTagsReference).doc(model.id);
      await doc.update(model.toJson());

      return model;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final doc = firestore.collection(constantTagsReference).doc(id);
      await doc.delete();
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
