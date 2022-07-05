import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../app_theme.dart';
import '../../../../exceptions/errors.dart';
import './i_image_cropper_facade.dart';

class ImageCropperFacade implements IImageCropperFacade {
  final ImageCropper imageCropper;

  ImageCropperFacade({required this.imageCropper});

  @override
  Future<File?> crop(File image) async {
    try {
      final CroppedFile? cropImage = await imageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarWidgetColor: Colors.white,
                toolbarColor: const AppTheme().dark,
                backgroundColor: const AppTheme().dark,
                dimmedLayerColor: const AppTheme().dark,
                activeControlsWidgetColor: const AppTheme().secondary,
              ),
            ],
          );

      if (cropImage?.path.isEmpty ?? true) return null;

      return File(cropImage!.path);
    } catch (e) {
      throw UnexpectedError();
    }
  }
}