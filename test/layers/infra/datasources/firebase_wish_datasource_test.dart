import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/infra/datasources/firebase_wish_datasource.dart';
import 'package:desejando_app/layers/infra/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../infra/models/model_extension.dart';
import '../../infra/models/model_factory.dart';
import 'mocks/firebase_firestore_spy.dart';

void main() {
  group("getById", () {
    late FirebaseWishDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final WishModel wish = ModelFactory.wish();
    final String wishId = wish.id!;
    final Map<String, dynamic> json = wish.toJson();

    void mockFirebaseException(String code) => firestore.mockDocumentSnapshotError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(data: json..addAll({'id': wishId}), doc: true);
      sut = FirebaseWishDataSource(firestore: firestore);
    });

    test("Deve chamar GetById e retornar os valores com sucesso", () async {
      final WishModel wishResponse = await sut.getById(wishId);
      expect(wishResponse.equals(wish), true);
    });

    test("Deve throw NotFoundInfraError se retornar dados inválidos", () {
      firestore.mockDocumentSnapshotWithParameters(DocumentSnapshotSpy({
        'id': "any_id",
        'wishlist_id': 'any_wishlistId',
        'description': 'any_description',
      }));

      final Future future = sut.getById(wishId);
      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw NotFoundInfraError se data() retornar null", () {
      firestore.mockDocumentSnapshotWithParameters(DocumentSnapshotSpy(null));

      final Future future = sut.getById(wishId);
      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw AbortedInfraError se get() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.getById(wishId);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.getById(wishId);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se get() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se get() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se get() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se get() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se get() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se get() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se get() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se get() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se get() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se get() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.getById(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.getById(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.getById(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.getById(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.getById(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("getByWishlist", () {
    late FirebaseWishDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final List<WishModel> wishlists = ModelFactory.wishes();
    final String wishlistId = faker.guid.guid();
    final List<Map<String, dynamic>> jsonList = wishlists.map((e) => e.toJson()..addAll({'id': e.id})).toList();

    void mockFirebaseException(String code) => firestore.mockQueryGetError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(datas: jsonList, where: true);
      sut = FirebaseWishDataSource(firestore: firestore);
    });

    test("Deve chamar GetByWishlist e retornar os valores com sucesso", () async {
      final List<WishModel> wishesResponse = await sut.getByWishlist(wishlistId);
      expect(wishesResponse.equals(wishlists), true);
    });

    test("Deve chamar getAll e ignorando dados inválidos", () async {
      final List<Map<String, dynamic>> jsonListTest = jsonList.map((e) => e).toList();

      var firestoreTest = FirestoreFirestoreSpy(datas: [{'id': "any_id", 'description': "any_description"}, ...jsonListTest], where: true);
      var sutTest = FirebaseWishDataSource(firestore: firestoreTest);

      final List<WishModel> wishesResponse = await sutTest.getByWishlist(wishlistId);
      expect(wishesResponse.equals(wishlists), true);
      expect(!wishesResponse.any((e) => e.id == "any_id"), true);
      expect(wishesResponse.length, jsonListTest.length);
    });

    test("Deve throw AbortedInfraError se get() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se get() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se get() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se get() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se get() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se get() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se get() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se get() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se get() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se get() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se get() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.getByWishlist(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("create", () {
    late FirebaseWishDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final WishModel wish = ModelFactory.wish(withId: false);
    final String wishId = faker.guid.guid();
    final Map<String, dynamic> json = wish.toJson()..addAll({'id': wishId});

    void mockFirebaseException(String code) => firestore.mockAddError(data: json, error: FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(data: json, add: true);
      sut = FirebaseWishDataSource(firestore: firestore);
    });

    test("Deve chamar Create e retornar os valores com sucesso", () async {
      final WishModel wishResponse = await sut.create(wish);
      expect(wishResponse.equals(WishModel.fromJson(wish.toJson()..addAll({'id': wishId}))), true);
    });

    test("Deve throw AbortedInfraError se add() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.create(wish);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.create(wish);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se add() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se add() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se add() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se add() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se add() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se add() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se add() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se add() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se add() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.create(wish);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se add() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.create(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.create(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.create(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.create(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.create(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("update", () {
    late FirebaseWishDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final WishModel wish = ModelFactory.wish();

    void mockFirebaseException(String code) => firestore.mockUpdateError(error: FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(update: true);
      sut = FirebaseWishDataSource(firestore: firestore);
    });

    test("Deve chamar Update e retornar os valores com sucesso", () async {
      final WishModel wishResponse = await sut.update(wish);
      expect(wishResponse.equals(wish), true);
    });

    test("Deve throw AbortedInfraError se update() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.update(wish);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.update(wish);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se update() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se update() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se update() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se update() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se update() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se update() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se update() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se update() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se update() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.update(wish);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se update() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.update(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.update(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.update(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.update(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.update(wish);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });

  group("delete", () {
    late FirebaseWishDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final String wishId = faker.guid.guid();

    void mockFirebaseException(String code) => firestore.mockDeleteError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(delete: true);
      sut = FirebaseWishDataSource(firestore: firestore);
    });

    test("Deve chamar Delete com sucesso", () async {
      await sut.delete(wishId);
      verify(() => firestore.collectionReferenceStubby.doc(wishId).delete());
    });

    test("Deve throw AbortedInfraError se delete() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.delete(wishId);
      expect(future, throwsA(isA<AbortedInfraError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.delete(wishId);
      expect(future, throwsA(isA<AbortedInfraError>()));
    });

    test("Deve throw AlreadyExistsInfraError se delete() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<AlreadyExistsInfraError>()));
    });

    test("Deve throw CancelledInfraError se delete() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<CancelledInfraError>()));
    });

    test("Deve throw InternalInfraError se delete() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<InternalInfraError>()));
    });

    test("Deve throw InvalidArgumentInfraError se delete() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<InvalidArgumentInfraError>()));
    });

    test("Deve throw NotFoundInfraError se delete() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve throw PermissionDeniedInfraError se delete() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<PermissionDeniedInfraError>()));
    });

    test("Deve throw ResourceExhaustedInfraError se delete() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<ResourceExhaustedInfraError>()));
    });

    test("Deve throw UnauthenticatedInfraError se delete() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<UnauthenticatedInfraError>()));
    });

    test("Deve throw UnavailableInfraError se delete() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<UnavailableInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se delete() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.delete(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.delete(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.delete(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.delete(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.delete(wishId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });
}
