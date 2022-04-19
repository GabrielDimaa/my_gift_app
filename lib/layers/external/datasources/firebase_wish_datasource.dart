import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infra/datasources/i_wish_datasource.dart';
import '../../infra/models/wish_model.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';

class FirebaseWishDataSource implements IWishDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishDataSource({required this.firestore});

  @override
  Future<WishModel> getById(String id) async {
    try {
      final Map<String, dynamic>? response = (await firestore.collection("wishs").doc(id).get()).data();
      response?.addAll({'id': id});

      if (!WishModel.validateJson(response)) throw NotFoundExternalError();

      return WishModel.fromJson(response!);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }
}