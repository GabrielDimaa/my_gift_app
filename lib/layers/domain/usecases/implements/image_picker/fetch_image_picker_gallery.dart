import 'dart:io';

import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../services/i_image_crop_service.dart';
import '../../../services/i_image_picker_service.dart';
import '../../abstracts/image_picker/i_fetch_image_picker_gallery.dart';

class FetchImagePickerGallery implements IFetchImagePickerGallery {
  final IImagePickerService imagePickerService;
  final IImageCropService imageCropService;

  FetchImagePickerGallery({required this.imagePickerService, required this.imageCropService});

  @override
  Future<File?> fetchFromGallery() async {
    File? image;

    try {
      image = await imagePickerService.getFromGallery();
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
