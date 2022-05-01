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
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<TagModel> update(TagModel model) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
