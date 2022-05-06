import 'dart:io';

import 'package:desejando_app/layers/external/datasources/storage/firebase_storage_datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/firebase_storage_spy.dart';

void main() {
  late FirebaseStorageDataSource sut;
  late FirebaseStorageSpy firebaseStorage;

  final String url = faker.internet.httpsUrl();
  final String path = "profile/${faker.guid.guid()}";
  final File file = File(faker.internet.httpUrl());

  setUp(() {
    firebaseStorage = FirebaseStorageSpy(url: url);
    sut = FirebaseStorageDataSource(firebaseStorage: firebaseStorage);
  });

  setUpAll(() => registerFallbackValue(file));

  test("Deve chamar upload e retornar uma url", () async {
    final String urlResponse = await sut.upload(path, file);
    expect(urlResponse, url);
  });
}