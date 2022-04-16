import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infra/datasources/i_desejo_datasource.dart';
import '../../infra/models/desejo_model.dart';
import '../helpers/external_error.dart';
import '../helpers/firebase_exception_extension.dart';

class FirebaseDesejoDataSource implements IDesejoDataSource {
  final FirebaseFirestore firestore;

  FirebaseDesejoDataSource({required this.firestore});

  @override
  Future<DesejoModel> getById(String id) async {
    try {
      final Map<String, dynamic>? response = (await firestore.collection("desejos").doc(id).get()).data();
      response?.addAll({'id': id});

      if (!DesejoModel.validateJson(response)) throw NotFoundExternalError();

      return DesejoModel.fromJson(response!);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }
}