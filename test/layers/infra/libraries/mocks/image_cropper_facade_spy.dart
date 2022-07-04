import 'dart:io';

import 'package:my_gift_app/layers/infra/libraries/image_crop/i_image_cropper_facade.dart';
import 'package:mocktail/mocktail.dart';

class ImageCropperFacadeSpy extends Mock implements IImageCropperFacade {
  ImageCropperFacadeSpy({File? file}) {
    mockCrop(file: file);
  }

  When mockCropCall() => when(() => crop(any()));
  void mockCrop({File? file}) => mockCropCall().thenAnswer((_) => Future.value(file));
  void mockCropError({Exception? error}) => mockCropCall().thenThrow(error ?? Exception("any_error"));
}
