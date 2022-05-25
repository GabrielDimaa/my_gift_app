import 'dart:io';

abstract class IFetchImagePickerCamera {
  Future<File?> fetchFromCamera();
}
