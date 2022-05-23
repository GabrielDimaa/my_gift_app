import 'dart:io';

abstract class IImageCropperFacade {
  Future<File?> crop(File image);
}