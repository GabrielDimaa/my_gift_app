import 'dart:io';

import '../../domain/services/i_image_crop_service.dart';
import '../helpers/errors/infra_error.dart';
import '../libraries/image_crop/i_image_cropper_facade.dart';

class ImageCropService implements IImageCropService {
  final IImageCropperFacade imageCropperFacade;

  ImageCropService({required this.imageCropperFacade});

  @override
  Future<File?> crop(File image) async {
    try {
      return await imageCropperFacade.crop(image);
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }
}
