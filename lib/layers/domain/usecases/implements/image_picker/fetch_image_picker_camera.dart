import 'dart:io';

import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../services/i_image_crop_service.dart';
import '../../../services/i_image_picker_service.dart';
import '../../abstracts/image_picker/i_fetch_image_picker_camera.dart';

class FetchImagePickerCamera implements IFetchImagePickerCamera {
  final IImagePickerService imagePickerService;
  final IImageCropService imageCropService;

  FetchImagePickerCamera({required this.imagePickerService, required this.imageCropService});

  @override
  Future<File?> fetchFromCamera() async {
    File? image;

    try {
      image = await imagePickerService.getFromCamera();
    } on UnexpectedError {
      throw StandardError(R.string.imagePickerError);
    }

    try {
      if (image != null) return await imageCropService.crop(image);
    } on UnexpectedError {
      throw StandardError(R.string.imagePickerError);
    }

    return null;
  }
}
