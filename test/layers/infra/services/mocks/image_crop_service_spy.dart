import 'dart:io';

import 'package:desejando_app/layers/domain/services/i_image_crop_service.dart';
import 'package:mocktail/mocktail.dart';

class ImageCropServiceSpy extends Mock implements IImageCropService {
  ImageCropServiceSpy({File? file}) {
    mockCrop(data: file);
  }

  When mockCropCall() => when(() => crop(any()));
  void mockCrop({File? data}) => mockCropCall().thenAnswer((_) => Future.value(data));
  void mockCropError({Exception? error}) => mockCropCall().thenThrow(error ?? Exception("any_error"));
}
