import 'dart:io';

import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/image_picker/fetch_image_picker_gallery.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/services/mocks/image_crop_service_spy.dart';
import '../../../infra/services/mocks/image_picker_service_spy.dart';

void main() {
  late FetchImagePickerGallery sut;
  late ImagePickerServiceSpy imagePickerServiceSpy;
  late ImageCropServiceSpy imageCropServiceSpy;

  final File fileResultPicker = File("any_path_picker");
  final File fileResultCropper = File("any_path_cropper");

  setUp(() {
    imagePickerServiceSpy = ImagePickerServiceSpy(file: fileResultPicker);
    imageCropServiceSpy = ImageCropServiceSpy(file: fileResultCropper);
    sut = FetchImagePickerGallery(imagePickerService: imagePickerServiceSpy, imageCropService: imageCropServiceSpy);
  });

  setUpAll(() => registerFallbackValue(fileResultCropper));

  test("Deve chamar picker e crop com valores corretos", () async {
    await sut.fetchFromGallery();
    verify(() => imageCropServiceSpy.crop(fileResultPicker));
  });

  test("Deve chamar picker e retornar null", () async {
    imagePickerServiceSpy.mockGetFromGallery();

    final File? file = await sut.fetchFromGallery();
    expect(file, null);
    verifyNever(() => imageCropServiceSpy.crop(fileResultPicker));
  });

  test("Deve chamar picker e crop retornar null", () async {
    imageCropServiceSpy.mockCrop();

    final File? file = await sut.fetchFromGallery();
    expect(file, null);
    verify(() => imageCropServiceSpy.crop(fileResultPicker)).called(1);
  });

  test("Deve throw UnexpectedError se getFromCamera throws", () {
    imagePickerServiceSpy.mockGetFromGalleryError(error: UnexpectedError());

    final Future future = sut.fetchFromGallery();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError se não tiver permissão pra acessar a galeria", () {
    imagePickerServiceSpy.mockGetFromGalleryError(error: StandardError());

    final Future future = sut.fetchFromGallery();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception se crop error", () {
    imageCropServiceSpy.mockCropError();

    final Future future = sut.fetchFromGallery();
    expect(future, throwsA(isA<Exception>()));
  });
}