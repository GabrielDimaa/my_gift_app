import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import './i_storage_datasource.dart';

class FirebaseStorageDataSource implements IStorageDataSource {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageDataSource({required this.firebaseStorage});

  @override
  Future<String> upload(String path, File file) async {
    try {
      final storage = firebaseStorage.ref().child(path);
      await storage.putFile(file);
      return await storage.getDownloadURL();
    } catch (e) {
      throw StandardError(R.string.uploadImageError);
    }
  }

  @override
  Future<void> delete(String path) async {
    try {
      final storage = firebaseStorage.ref().child(path);
      await storage.delete();
    } catch (e) {
      throw StandardError(R.string.deleteImageError);
    }
  }
}
