import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/external/datasources/firebase_wishlist_datasource.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../infra/models/model_factory.dart';
import '../mocks/firebase_firestore_spy.dart';

void main() {
  group("getById", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final WishlistModel wishlist = ModelFactory.wishlist();
    final String wishlistId = wishlist.id;
    final Map<String, dynamic> json = wishlist.toJson();

    void mockFirebaseException(String code) => firestore.mockDocumentSnapshotError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy.doc(json);
      sut = FirebaseWishlistDataSource(firestore: firestore);
    });

    test("Deve chamar GetById e retornar os valores com sucesso", () async {
      final WishlistModel wishlistResponse = await sut.getById(wishlistId);
      expect(wishlistResponse, wishlist);
    });

    test("Deve throw NotFoundExternalError se data() retornar null", () {
      firestore.mockDocumentSnapshotWithParameters(DocumentSnapshotSpy(null));

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw AbortedExternalError se get() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<AbortedExternalError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.getById(wishlistId);
      expect(future, throwsA(isA<AbortedExternalError>()));
    });

    test("Deve throw AlreadyExistsExternalError se get() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<AlreadyExistsExternalError>()));
    });

    test("Deve throw CancelledExternalError se get() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<CancelledExternalError>()));
    });

    test("Deve throw InternalExternalError se get() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<InternalExternalError>()));
    });

    test("Deve throw InvalidArgumentExternalError se get() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<InvalidArgumentExternalError>()));
    });

    test("Deve throw NotFoundExternalError se get() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw PermissionDeniedExternalError se get() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<PermissionDeniedExternalError>()));
    });

    test("Deve throw ResourceExhaustedExternalError se get() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
    });

    test("Deve throw UnauthenticatedExternalError se get() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<UnauthenticatedExternalError>()));
    });

    test("Deve throw UnavailableExternalError se get() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.getById(wishlistId);

      expect(future, throwsA(isA<UnavailableExternalError>()));
    });

    test("Deve throw UnexpectedExternalError se get() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));
    });
  });
}