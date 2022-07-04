import 'dart:io';

import 'package:my_gift_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:my_gift_app/layers/infra/libraries/image_picker/image_picker_facade.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/image_picker_spy.dart';

void main() {
  late ImagePickerFacade sut;
  late ImagePickerSpy imagePickerSpy;

  final XFile fileResult = XFile("any_path");

  group("camera", () {
    setUp(() {
      imagePickerSpy = ImagePickerSpy(source: ImageSource.camera, file: fileResult);
      sut = ImagePickerFacade(imagePicker: imagePickerSpy);
    });

    test("Deve chamar getFromCamera com valores corretos", () async {
      await sut.getFromCamera();
      verify(() => imagePickerSpy.pickImage(source: ImageSource.camera));
    });

    test("Deve chamar getFromCamera e retornar o valor corretamente", () async {
      final File? file = await sut.getFromCamera();
      expect(file?.path, fileResult.path);
    });

    test("Deve chamar getFromCamera e retornar null", () async {
      imagePickerSpy.mockPickImage(file: null);

      final File? file = await sut.getFromCamera();
      expect(file?.path, null);
    });

    test("Deve throw WithoutPermissionInfraError se PlatformException", () {
      imagePickerSpy.mockPickImageError(error: PlatformException(code: "any_code"));

      final Future future = sut.getFromCamera();
      expect(future, throwsA(isA<WithoutPermissionInfraError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      imagePickerSpy.mockPickImageError();

      final Future future = sut.getFromCamera();
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("gallery", () {
    setUp(() {
      imagePickerSpy = ImagePickerSpy(source: ImageSource.gallery, file: fileResult);
      sut = ImagePickerFacade(imagePicker: imagePickerSpy);
    });

    test("Deve chamar getFromGallery com valores corretos", () async {
      await sut.getFromGallery();
      verify(() => imagePickerSpy.pickImage(source: ImageSource.gallery));
    });

    test("Deve chamar getFromGallery e retornar o valor corretamente", () async {
      final File? file = await sut.getFromGallery();
      expect(file?.path, fileResult.path);
    });

    test("Deve chamar getFromGallery e retornar null", () async {
      imagePickerSpy.mockPickImage(file: null);

      final File? file = await sut.getFromGallery();
      expect(file?.path, null);
    });

    test("Deve throw WithoutPermissionInfraError se PlatformException", () {
      imagePickerSpy.mockPickImageError(error: PlatformException(code: "any_code"));

      final Future future = sut.getFromGallery();
      expect(future, throwsA(isA<WithoutPermissionInfraError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      imagePickerSpy.mockPickImageError();

      final Future future = sut.getFromGallery();
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });
}
