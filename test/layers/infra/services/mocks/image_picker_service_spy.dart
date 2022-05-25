import 'dart:io';

import 'package:desejando_app/layers/domain/services/i_image_picker_service.dart';
import 'package:mocktail/mocktail.dart';

class ImagePickerServiceSpy extends Mock implements IImagePickerService {
  ImagePickerServiceSpy({File? file}) {
    mockGetFromCamera(data: file);
    mockGetFromGallery(data: file);
  }

  //region getFromCamera
  When mockGetFromCameraCall() => when(() => getFromCamera());
  void mockGetFromCamera({File? data}) => mockGetFromCameraCall().thenAnswer((_) => Future.value(data));
  void mockGetFromCameraError({Exception? error}) => mockGetFromCameraCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getFromGallery
  When mockGetFromGalleryCall() => when(() => getFromGallery());
  void mockGetFromGallery({File? data}) => mockGetFromGalleryCall().thenAnswer((_) => Future.value(data));
  void mockGetFromGalleryError({Exception? error}) => mockGetFromGalleryCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
