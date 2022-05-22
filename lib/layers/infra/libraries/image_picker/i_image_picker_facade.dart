import 'dart:io';

abstract class IImagePickerFacade {
  Future<File?> getFromCamera();
  Future<File?> getFromGallery();
}