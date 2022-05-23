import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mocktail/mocktail.dart';

class ImageCropperSpy extends Mock implements ImageCropper {
  ImageCropperSpy({CroppedFile? file}) {
    mockCropImage(file: file);
  }

  When mockCropImageCall() => when(
        () => cropImage(
          sourcePath: any(named: "sourcePath"),
          aspectRatio: any(named: "aspectRatio"),
          uiSettings: any(named: "uiSettings"),
          aspectRatioPresets: any(named: "aspectRatioPresets"),
          compressFormat: any(named: "compressFormat"),
          compressQuality: any(named: "compressQuality"),
          cropStyle: any(named: "cropStyle"),
          maxHeight: any(named: "maxHeight"),
          maxWidth: any(named: "maxWidth"),
        ),
      );

  void mockCropImage({CroppedFile? file}) => mockCropImageCall().thenAnswer((_) => Future.value(file));
  void mockCropImageError({Exception? error}) => mockCropImageCall().thenThrow(error ?? Exception("any_error"));
}
