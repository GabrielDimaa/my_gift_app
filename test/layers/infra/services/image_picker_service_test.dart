import 'dart:io';

import 'package:my_gift_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:my_gift_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:my_gift_app/layers/infra/services/image_picker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../libraries/mocks/image_picker_facade_spy.dart';

void main() {
  late ImagePickerService sut;
  late ImagePickerFacadeSpy imagePickerFacadeSpy;

  final File fileResult = File("any_path");

  setUp(() {
    imagePickerFacadeSpy = ImagePickerFacadeSpy(file: fileResult);
    sut = ImagePickerService(imagePickerFacade: imagePickerFacadeSpy);
  });

  setUpAll(() => registerFallbackValue(fileResult));

  group("getFromCamera", () {
    test("Deve chamar getFromCamera e retornar os valores corretamente", () async {
      final File? file = await sut.getFromCamera();
      expect(file!.path, fileResult.path);
    });

    test("Deve chamar getFromCamera e retornar null", () async {
      imagePickerFacadeSpy.mockGetFromCamera();

      final File? file = await sut.getFromCamera();
      expect(file, null);
    });

    test("Deve throw WithoutPermissionDomainError se WithoutPermissionInfraError", () {
      imagePickerFacadeSpy.mockGetFromCameraError(error: WithoutPermissionInfraError());

      final Future future = sut.getFromCamera();
      expect(future, throwsA(isA<WithoutPermissionDomainError>()));
    });

    test("Deve throw Exception", () {
      imagePickerFacadeSpy.mockGetFromCameraError();

      final Future future = sut.getFromCamera();
      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedInfraError", () {
      imagePickerFacadeSpy.mockGetFromCameraError(error: UnexpectedInfraError());

      final Future future = sut.getFromCamera();
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("getFromGallery", () {
    test("Deve chamar getFromGallery e retornar os valores corretamente", () async {
      final File? file = await sut.getFromGallery();
      expect(file!.path, fileResult.path);
    });

    test("Deve chamar getFromGallery e retornar null", () async {
      imagePickerFacadeSpy.mockGetFromGallery();

      final File? file = await sut.getFromGallery();
      expect(file, null);
    });

    test("Deve throw WithoutPermissionDomainError se WithoutPermissionInfraError", () {
      imagePickerFacadeSpy.mockGetFromGalleryError(error: WithoutPermissionInfraError());

      final Future future = sut.getFromGallery();
      expect(future, throwsA(isA<WithoutPermissionDomainError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      imagePickerFacadeSpy.mockGetFromGalleryError(error: UnexpectedInfraError());

      final Future future = sut.getFromGallery();
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw Exception", () {
      imagePickerFacadeSpy.mockGetFromGalleryError();

      final Future future = sut.getFromGallery();
      expect(future, throwsA(isA()));
    });
  });
}