import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infra/datasources/i_tag_datasource.dart';
import '../../infra/models/tag_model.dart';
import '../constants/collection_reference.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';

class FirebaseTagDataSource implements ITagDataSource {
  final FirebaseFirestore firestore;

  FirebaseTagDataSource({required this.firestore});

  @override
  Future<List<TagModel>> getAll(userId) async {
    try {
      final snapshot = await firestore.collection(constantTagsReference).where("user_id", isEqualTo: userId).get();
      final jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) {
          return json;
        }
        return json..addAll({'id': e.id});
      }).toList();

      List<TagModel> tagsModel = [];

      for (var json in jsonList) {
        if (TagModel.validateJson(json)) {
          tagsModel.add(TagModel.fromJson(json));
        }
      }

      return tagsModel;
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<TagModel> create(TagModel model) async {
    try {
      final Map<String, dynamic> json = model.toJson();

      final doc = await firestore.collection(constantTagsReference).add(json);
      json.addAll({'id': doc.id});

      if (!TagModel.validateJson(json)) throw UnexpectedExternalError();

      return TagModel.fromJson(json);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<TagModel> update(TagModel model) async {
    try {
      final doc = firestore.collection(constantTagsReference).doc(model.id);
      await doc.update(model.toJson());

      return model;
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final doc = firestore.collection(constantTagsReference).doc(id);
      await doc.delete();
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }
}
