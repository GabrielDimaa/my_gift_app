import 'dart:io';

import '../../../../../i18n/resources.dart';
import '../../../helpers/errors/domain_error.dart';
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
    } on DomainError catch (e) {
      if (e is WithoutPermissionDomainError) throw WithoutPermissionDomainError(message: "Sem permissão para acessar a câmera.");
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.imagePickerError);
    }

    try {
      if (image != null) return await imageCropService.crop(image);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.imageCropperError);
    }

    return null;
  }
}
