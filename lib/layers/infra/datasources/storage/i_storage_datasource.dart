import 'dart:io';

abstract class IStorageDataSource {
  Future<String> upload(String path, File file);
  Future<void> delete(String path);
}