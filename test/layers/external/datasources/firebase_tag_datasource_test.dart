import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/external/datasources/firebase_tag_datasource.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../infra/models/model_extension.dart';
import '../../infra/models/model_factory.dart';
import '../mocks/firebase_firestore_spy.dart';

void main() {
  late FirebaseTagDataSource sut;
  late FirestoreFirestoreSpy firestoreSpy;

  final List<TagModel> tags = ModelFactory.tags();
  final String userId = faker.guid.guid();
  final List<Map<String, dynamic>> jsonList = tags.map((e) => e.toJson()..addAll({'id': e.id})).toList();

  void mockFirebaseException(String code) => firestoreSpy.mockQueryGetError(FirebaseException(plugin: "any_plugin", code: code));

  setUp(() {
    firestoreSpy = FirestoreFirestoreSpy.where(jsonList);
    sut = FirebaseTagDataSource(firestore: firestoreSpy);
  });

  test("Deve chamar getAll e retornar dados com sucesso", () async {
    final List<TagModel> tagsResponse = await sut.getAll(userId);
    expect(tagsResponse.equals(tags), true);
  });

  test("Deve throw AbortedExternalError se getAll() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
    mockFirebaseException("ABORTED");
    Future future = sut.getAll(userId);
    expect(future, throwsA(isA<AbortedExternalError>()));

    mockFirebaseException("FAILED_PRECONDITION");
    future = sut.getAll(userId);
    expect(future, throwsA(isA<AbortedExternalError>()));
  });

  test("Deve throw AlreadyExistsExternalError se getAll() retornar FirebaseException com code ALREADY_EXISTS", () {
    mockFirebaseException("ALREADY_EXISTS");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<AlreadyExistsExternalError>()));
  });

  test("Deve throw CancelledExternalError se getAll() retornar FirebaseException com code CANCELLED", () {
    mockFirebaseException("CANCELLED");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<CancelledExternalError>()));
  });

  test("Deve throw InternalExternalError se getAll() retornar FirebaseException com code INTERNAL", () {
    mockFirebaseException("INTERNAL");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<InternalExternalError>()));
  });

  test("Deve throw InvalidArgumentExternalError se getAll() retornar FirebaseException com code INVALID_ARGUMENT", () {
    mockFirebaseException("INVALID_ARGUMENT");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<InvalidArgumentExternalError>()));
  });

  test("Deve throw NotFoundExternalError se getAll() retornar FirebaseException com code NOT_FOUND", () {
    mockFirebaseException("NOT_FOUND");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<NotFoundExternalError>()));
  });

  test("Deve throw PermissionDeniedExternalError se getAll() retornar FirebaseException com code PERMISSION_DENIED", () {
    mockFirebaseException("PERMISSION_DENIED");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<PermissionDeniedExternalError>()));
  });

  test("Deve throw ResourceExhaustedExternalError se getAll() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
    mockFirebaseException("RESOURCE_EXHAUSTED");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
  });

  test("Deve throw UnauthenticatedExternalError se getAll() retornar FirebaseException com code UNAUTHENTICATED", () {
    mockFirebaseException("UNAUTHENTICATED");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<UnauthenticatedExternalError>()));
  });

  test("Deve throw UnavailableExternalError se getAll() retornar FirebaseException com code UNAVAILABLE", () {
    mockFirebaseException("UNAVAILABLE");
    final Future future = sut.getAll(userId);

    expect(future, throwsA(isA<UnavailableExternalError>()));
  });

  test("Deve throw UnexpectedExternalError se getAll() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
    mockFirebaseException("DATA_LOSS");
    Future future = sut.getAll(userId);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    mockFirebaseException("DEADLINE_EXCEEDED");
    future = sut.getAll(userId);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    mockFirebaseException("OUT_OF_RANGE");
    future = sut.getAll(userId);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    mockFirebaseException("UNIMPLEMENTED");
    future = sut.getAll(userId);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    mockFirebaseException("UNKNOWN");
    future = sut.getAll(userId);
    expect(future, throwsA(isA<UnexpectedExternalError>()));
  });
}
