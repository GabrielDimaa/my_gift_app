import 'dart:io';

import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/infra/services/image_crop_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../libraries/mocks/image_cropper_facade_spy.dart';

void main() {
  late ImageCropService sut;
  late ImageCropperFacadeSpy imageCropperFacadeSpy;

  final File fileResult = File("any_path");

  setUp(() {
    imageCropperFacadeSpy = ImageCropperFacadeSpy(file: fileResult);
    sut = ImageCropService(imageCropperFacade: imageCropperFacadeSpy);
  });

  setUpAll(() => registerFallbackValue(fileResult));

  test("Deve chamar crop com valores corretos", () async {
    await sut.crop(fileResult);
    verify(() => imageCropperFacadeSpy.crop(fileResult));
  });

  test("Deve chamar crop e retornar os valores corretamente", () async {
    final File? file = await sut.crop(fileResult);
    expect(file?.path, fileResult.path);
  });

  test("Deve chamar crop e retornar null", () async {
    imageCropperFacadeSpy.mockCrop();

    final File? file = await sut.crop(fileResult);
    expect(file, null);
  });

  test("Deve throw UnexpectedDomainError", () {
    imageCropperFacadeSpy.mockCropError();

    final Future future = sut.crop(fileResult);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}