import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/errors/infra_error.dart';
import './i_image_picker_facade.dart';

class ImagePickerFacade implements IImagePickerFacade {
  final ImagePicker imagePicker;

  ImagePickerFacade({required this.imagePicker});

  @override
  Future<File?> getFromCamera() async {
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);

      if (image?.path.isEmpty ?? true) return null;
      return File(image!.path);
    } on PlatformException {
      throw WithoutPermissionInfraError();
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<File?> getFromGallery() async {
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image?.path.isEmpty ?? true) return null;
      return File(image!.path);
    } on PlatformException {
      throw WithoutPermissionInfraError();
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
