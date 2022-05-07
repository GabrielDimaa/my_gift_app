import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/infra/datasources/firebase_tag_datasource.dart';
import 'package:desejando_app/layers/infra/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../infra/models/model_extension.dart';
import '../../infra/models/model_factory.dart';
import 'mocks/firebase_firestore_spy.dart';

void main() {
  late FirebaseTagDataSource sut;
  late FirestoreFirestoreSpy firestoreSpy;

  group("getAll", () {
    final List<TagModel> tags = ModelFactory.tags();
    final String userId = faker.guid.guid();
    final List<Map<String, dynamic>> jsonList = tags.map((e) => e.toJson()..addAll({'id': e.id})).toList();

    void mockFirebaseException(String code) => firestoreSpy.mockQueryGetError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestoreSpy = FirestoreFirestoreSpy(datas: jsonList, where: true);
      sut = FirebaseTagDataSource(firestore: firestoreSpy);
    });

    test("Deve chamar getAll e retornar dados com sucesso", () async {
      final List<TagModel> tagsResponse = await sut.getAll(userId);
      expect(tagsResponse.equals(tags), true);
    });

    test("Deve chamar getAll e ignorando dados inválidos", () async {
      final List<Map<String, dynamic>> jsonListTest = jsonList.map((e) => e).toList();

      var firestoreTest = FirestoreFirestoreSpy(datas: [{'id': "any_id", 'name': "any_tag"}, ...jsonListTest], where: true);
      var sutTest = FirebaseTagDataSource(firestore: firestoreTest);

      final List<TagModel> tagsResponse = await sutTest.getAll(userId);
      expect(tagsResponse.equals(tags), true);
      expect(!tagsResponse.any((e) => e.id == "any_id"), true);
      expect(jsonListTest.length, tagsResponse.length);
    });

    test("Deve throw AbortedInfraError se getAll() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.getAll(userId);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.getAll(userId);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se getAll() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se getAll() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se getAll() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se getAll() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se getAll() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se getAll() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se getAll() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se getAll() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se getAll() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se getAll() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("create", () {
    final TagModel tag = ModelFactory.tag(withId: false);
    final String tagId = faker.guid.guid();
    final Map<String, dynamic> json = tag.toJson()..addAll({'id': tagId});

    void mockFirebaseException(String code) => firestoreSpy.mockAddError(data: json, error: FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestoreSpy = FirestoreFirestoreSpy(data: json, add: true);
      sut = FirebaseTagDataSource(firestore: firestoreSpy);
    });

    test("Deve chamar create e retornar os valores com sucesso", () async {
      final TagModel tagResponse = await sut.create(tag);
      expect(tagResponse.id == tagId, true);
      expect(tagResponse.equals(tag.clone(id: tagId)), true);
    });

    test("Deve throw AbortedInfraError se add() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.create(tag);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.create(tag);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se add() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se add() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se add() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se add() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se add() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se add() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se add() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se add() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se add() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.create(tag);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se add() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.create(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.create(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.create(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.create(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.create(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("update", () {
    final TagModel tag = ModelFactory.tag();

    void mockFirebaseException(String code) => firestoreSpy.mockUpdateError(error: FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestoreSpy = FirestoreFirestoreSpy(update: true);
      sut = FirebaseTagDataSource(firestore: firestoreSpy);
    });

    test("Deve chamar update e retornar os valores com sucesso", () async {
      final TagModel tagResponse = await sut.update(tag);
      expect(tagResponse.equals(tag), true);
    });

    test("Deve throw AbortedInfraError se update() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.update(tag);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.update(tag);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se update() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se update() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se update() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se update() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se update() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se update() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se update() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se update() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se update() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.update(tag);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se update() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.update(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.update(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.update(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.update(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.update(tag);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("delete", () {
    final String tagId = faker.guid.guid();

    void mockFirebaseException(String code) => firestoreSpy.mockDeleteError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestoreSpy = FirestoreFirestoreSpy(delete: true);
      sut = FirebaseTagDataSource(firestore: firestoreSpy);
    });

    test("Deve chamar delete com sucesso", () async {
      await sut.delete(tagId);
      verify(() => firestoreSpy.collectionReferenceStubby.doc(tagId).delete());
    });

    test("Deve throw AbortedInfraError se delete() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.delete(tagId);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.delete(tagId);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se delete() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se delete() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se delete() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se delete() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se delete() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se delete() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se delete() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se delete() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se delete() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.delete(tagId);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se delete() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.delete(tagId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.delete(tagId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.delete(tagId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.delete(tagId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.delete(tagId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });
}
