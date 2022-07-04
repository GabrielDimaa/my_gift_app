import 'dart:io';

import 'package:my_gift_app/layers/infra/libraries/image_picker/i_image_picker_facade.dart';
import 'package:mocktail/mocktail.dart';

class ImagePickerFacadeSpy extends Mock implements IImagePickerFacade {
  ImagePickerFacadeSpy({File? file}) {
    mockGetFromCamera(file: file);
    mockGetFromGallery(file: file);
  }

  //region getFromCamera
  When mockGetFromCameraCall() => when(() => getFromCamera());
  void mockGetFromCamera({File? file}) => mockGetFromCameraCall().thenAnswer((_) => Future.value(file));
  void mockGetFromCameraError({Exception? error}) => mockGetFromCameraCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getFromGallery
  When mockGetFromGalleryCall() => when(() => getFromGallery());
  void mockGetFromGallery({File? file}) => mockGetFromGalleryCall().thenAnswer((_) => Future.value(file));
  void mockGetFromGalleryError({Exception? error}) => mockGetFromGalleryCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}