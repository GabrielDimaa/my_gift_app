import 'dart:io';

import 'package:my_gift_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/image_picker/fetch_image_picker_camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/services/mocks/image_crop_service_spy.dart';
import '../../../infra/services/mocks/image_picker_service_spy.dart';

void main() {
  late FetchImagePickerCamera sut;
  late ImagePickerServiceSpy imagePickerServiceSpy;
  late ImageCropServiceSpy imageCropServiceSpy;

  final File fileResultPicker = File("any_path_picker");
  final File fileResultCropper = File("any_path_cropper");

  setUp(() {
    imagePickerServiceSpy = ImagePickerServiceSpy(file: fileResultPicker);
    imageCropServiceSpy = ImageCropServiceSpy(file: fileResultCropper);
    sut = FetchImagePickerCamera(imagePickerService: imagePickerServiceSpy, imageCropService: imageCropServiceSpy);
  });

  setUpAll(() => registerFallbackValue(fileResultCropper));

  test("Deve chamar picker e crop com valores corretos", () async {
    await sut.fetchFromCamera();
    verify(() => imageCropServiceSpy.crop(fileResultPicker));
  });

  test("Deve chamar picker e retornar null", () async {
    imagePickerServiceSpy.mockGetFromCamera();

    final File? file = await sut.fetchFromCamera();
    expect(file, null);
    verifyNever(() => imageCropServiceSpy.crop(fileResultPicker));
  });

  test("Deve chamar picker e crop retornar null", () async {
    imageCropServiceSpy.mockCrop();

    final File? file = await sut.fetchFromCamera();
    expect(file, null);
    verify(() => imageCropServiceSpy.crop(fileResultPicker)).called(1);
  });

  test("Deve throw UnexpectedDomainError se getFromCamera throws", () {
    imagePickerServiceSpy.mockGetFromCameraError();

    final Future future = sut.fetchFromCamera();
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw WithoutPermissionDomainError se não tiver permissão pra câmera", () {
    imagePickerServiceSpy.mockGetFromCameraError(error: WithoutPermissionDomainError());

    final Future future = sut.fetchFromCamera();
    expect(future, throwsA(isA<WithoutPermissionDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se crop error", () {
    imageCropServiceSpy.mockCropError();

    final Future future = sut.fetchFromCamera();
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}