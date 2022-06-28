import 'dart:io';

import '../../domain/services/i_image_picker_service.dart';
import '../helpers/errors/infra_error.dart';
import '../libraries/image_picker/i_image_picker_facade.dart';

class ImagePickerService implements IImagePickerService {
  final IImagePickerFacade imagePickerFacade;

  ImagePickerService({required this.imagePickerFacade});

  @override
  Future<File?> getFromCamera() async {
    try {
      return await imagePickerFacade.getFromCamera();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<File?> getFromGallery() async {
    try {
      return await imagePickerFacade.getFromGallery();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }
}
