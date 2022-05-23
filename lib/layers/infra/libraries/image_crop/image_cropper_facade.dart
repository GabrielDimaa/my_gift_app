import 'dart:io';

import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import './i_image_cropper_facade.dart';

class ImageCropperFacade implements IImageCropperFacade {
  final ImageCropper imageCropper;

  ImageCropperFacade(this.imageCropper);

  @override
  Future<File?> crop(File image) async {
    try {
      final CroppedFile? cropImage = await imageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarWidgetColor: Colors.white,
                toolbarColor: Colors.yellow,
                statusBarColor: Colors.red,
                backgroundColor: Colors.green,
                dimmedLayerColor: Colors.blue,
                activeControlsWidgetColor: Colors.black,
              ),
            ],
          );

      if (cropImage?.path.isEmpty ?? true) return null;

      return File(cropImage!.path);
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}