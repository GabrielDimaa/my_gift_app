import 'dart:io';

abstract class IImagePickerService {
  Future<File?> getFromCamera();
  Future<File?> getFromGallery();
}