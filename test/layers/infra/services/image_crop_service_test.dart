import 'dart:io';

import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/infra/services/image_crop_service.dart';
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

  test("Deve throw Exception", () {
    imageCropperFacadeSpy.mockCropError();

    final Future future = sut.crop(fileResult);
    expect(future, throwsA(isA()));
  });

  test("Deve throw UnexpectedInfraError", () {
    imageCropperFacadeSpy.mockCropError(error: UnexpectedError());

    final Future future = sut.crop(fileResult);
    expect(future, throwsA(isA<UnexpectedError>()));
  });
}