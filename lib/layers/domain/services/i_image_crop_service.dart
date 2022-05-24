import 'dart:io';

abstract class IImageCropService {
  Future<File?> crop(File image);
}