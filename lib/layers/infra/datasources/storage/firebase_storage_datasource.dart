import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../i18n/resources.dart';
import '../../helpers/errors/infra_error.dart';
import './i_storage_datasource.dart';

class FirebaseStorageDataSource implements IStorageDataSource {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageDataSource({required this.firebaseStorage});

  @override
  Future<String> upload(String path, File file) async {
    final storage = firebaseStorage.ref().child(path);
    final UploadTask uploadTask = storage.putFile(file);

    return await uploadTask
        .then((snapshot) => snapshot.ref.getDownloadURL())
        .catchError(throw UnexpectedInfraError(message: R.string.uploadImageError));
  }

  @override
  Future<void> delete(String path) async {
    try {
      final storage = firebaseStorage.ref().child(path);
      await storage.delete();
    } catch (e) {
      throw UnexpectedInfraError(message: R.string.deleteImageError);
    }
  }
}
