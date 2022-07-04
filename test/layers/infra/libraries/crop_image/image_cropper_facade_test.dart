import 'dart:io';

import 'package:my_gift_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:my_gift_app/layers/infra/libraries/image_crop/image_cropper_facade.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/image_cropper_spy.dart';

void main() {
  late ImageCropperFacade sut;
  late ImageCropperSpy imageCropperSpy;

  const String path = "any_path";
  final File fileResult = File(path);

  setUp(() {
    imageCropperSpy = ImageCropperSpy(file: CroppedFile(path));
    sut = ImageCropperFacade(imageCropper: imageCropperSpy);
  });

  setUpAll(() {
    registerFallbackValue(ImageCompressFormat.jpg);
    registerFallbackValue(CropStyle.rectangle);
  });

  test("Deve chamar crop e retornar o valor corretamente", () async {
    final File? image = await sut.crop(fileResult);
    expect(image?.path, fileResult.path);
  });

  test("Deve chamar crop e retornar null se path for vazio", () async {
    imageCropperSpy.mockCropImage(file: CroppedFile(""));

    final File? image = await sut.crop(fileResult);
    expect(image, null);
  });

  test("Deve chamar crop e retornar null se CroppedFile for null", () async {
    imageCropperSpy.mockCropImage(file: null);

    final File? image = await sut.crop(fileResult);
    expect(image, null);
  });

  test("Deve throw UnexpectedInfraError", () {
    imageCropperSpy.mockCropImageError();

    final Future future = sut.crop(fileResult);
    expect(future, throwsA(isA<UnexpectedInfraError>()));
  });
}