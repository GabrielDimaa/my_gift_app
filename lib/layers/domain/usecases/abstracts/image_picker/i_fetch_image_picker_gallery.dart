import 'dart:io';

abstract class IFetchImagePickerGallery {
  Future<File?> fetchFromGallery();
}
