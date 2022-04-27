import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infra/datasources/i_wish_datasource.dart';
import '../../infra/models/wish_model.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';

class FirebaseWishDataSource implements IWishDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishDataSource({required this.firestore});

  static const String _collectionPath = "wishes";

  @override
  Future<WishModel> getById(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_collectionPath).doc(id).get();
      final Map<String, dynamic>? json = snapshot.data();

      json?.addAll({'id': snapshot.id});

      if (!WishModel.validateJson(json)) throw NotFoundExternalError();

      return WishModel.fromJson(json!);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<WishModel> create(WishModel entity) async {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<WishModel> update(WishModel entity) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
