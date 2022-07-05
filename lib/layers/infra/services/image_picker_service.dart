import 'dart:io';

import '../../domain/services/i_image_picker_service.dart';
import '../libraries/image_picker/i_image_picker_facade.dart';

class ImagePickerService implements IImagePickerService {
  final IImagePickerFacade imagePickerFacade;

  ImagePickerService({required this.imagePickerFacade});

  @override
  Future<File?> getFromCamera() async {
    return await imagePickerFacade.getFromCamera();
  }

  @override
  Future<File?> getFromGallery() async {
    return await imagePickerFacade.getFromGallery();
  }
}
