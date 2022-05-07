import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/infra/constants/collection_reference.dart';
import 'package:desejando_app/layers/infra/datasources/firebase_wishlist_datasource.dart';
import 'package:desejando_app/layers/infra/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../infra/models/model_extension.dart';
import '../../infra/models/model_factory.dart';
import 'mocks/firebase_firestore_spy.dart';

void main() {
  group("getById", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final String wishlistId = faker.guid.guid();
    final WishlistModel wishlist = ModelFactory.wishlist(id: wishlistId);
    final Map<String, dynamic> json = wishlist.toJson()..addAll({'wishes': wishlist.wishes.map((e) => e.toJson()..addAll({'id': e.id})).toList()});

    void mockFirebaseException(String code) => firestore.mockDocumentSnapshotError(FirebaseException(plugin: "any_plugin", code: code));

    final DocumentReferenceStubby doc = DocumentReferenceStubby();
    final DocumentSnapshotSpy snapshot = DocumentSnapshotSpy(wishlist.tag.toJson()..addAll({'id': wishlist.tag.id}));
    void mockDoc() => when(() => firestore.collectionReferenceStubby.doc(wishlist.tag.id)).thenReturn(doc);
    void mockGet({DocumentSnapshotSpy? value}) => when(() => doc.get()).thenAnswer((_) =>  Future.value(value ?? snapshot));

    setUp(() {
      firestore = FirestoreFirestoreSpy(doc: true, where: true, data: json, datas: json['wishes']);
      sut = FirebaseWishlistDataSource(firestore: firestore);

      mockDoc();
      mockGet();
    });

    test("Deve chamar GetById e retornar os valores com sucesso", () async {
      final WishlistModel wishlistResponse = await sut.getById(wishlistId);
      expect(wishlistResponse.equals(wishlist), true);
    });

    test("Deve throw NotFoundExternalError se data() retornar null", () {
      firestore.mockDocumentSnapshotWithParameters(DocumentSnapshotSpy(null));

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw NotFoundExternalError se retornar tag igual a null", () {
      mockGet(value: DocumentSnapshotSpy(null));

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

  group("getAll", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final List<WishlistModel> wishlists = ModelFactory.wishlists();
    final String userId = faker.guid.guid();
    final List<Map<String, dynamic>> jsonList = wishlists.map((e) => e.toJson()..addAll({'wishes': e.wishes.map((it) => it.toJson()..addAll({'id': it.id})).toList()})).toList();
    final List<TagModel> tags = [];

    void mockFirebaseException(String code) => firestore.mockQueryGetError(FirebaseException(plugin: "any_plugin", code: code));

    void fetchTagsById() {
      for (var wishlist in wishlists) {
        if (!tags.any((e) => e.id == wishlist.tag.id)) {
          tags.add(ModelFactory.tag(id: wishlist.tag.id));
        }
      }
    }

    final QuerySpy querySpy = QuerySpy();
    void mockQuery() => when(() => firestore.collectionReferenceStubby.where(FieldPath.documentId, whereIn: any(named: "whereIn"))).thenReturn(querySpy);
    void mockGet({QuerySnapshotSpy? snapshot}) => when(() => querySpy.get()).thenAnswer((_) => Future.value(snapshot ?? QuerySnapshotSpy(tags.map((e) => e.toJson()..addAll({'id': e.id})).toList())));

    setUp(() {
      firestore = FirestoreFirestoreSpy(datas: jsonList, where: true);
      sut = FirebaseWishlistDataSource(firestore: firestore);

      fetchTagsById();
      mockQuery();
      mockGet();
    });

    test("Deve chamar GetAll e retornar os valores com sucesso", () async {
      final List<WishlistModel> wishlistsResponse = await sut.getAll(userId);
      expect(wishlistsResponse.equals(wishlists), true);
    });

    test("Deve throw UnexpectedExternalError se retornar tags inválidas", () {
      mockGet(snapshot: QuerySnapshotSpy([{'id': "any_id"}]));

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));
    });

    test("Deve throw AbortedExternalError se get() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.getAll(userId);
      expect(future, throwsA(isA<AbortedExternalError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.getAll(userId);
      expect(future, throwsA(isA<AbortedExternalError>()));
    });

    test("Deve throw AlreadyExistsExternalError se get() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<AlreadyExistsExternalError>()));
    });

    test("Deve throw CancelledExternalError se get() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<CancelledExternalError>()));
    });

    test("Deve throw InternalExternalError se get() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<InternalExternalError>()));
    });

    test("Deve throw InvalidArgumentExternalError se get() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<InvalidArgumentExternalError>()));
    });

    test("Deve throw NotFoundExternalError se get() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw PermissionDeniedExternalError se get() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<PermissionDeniedExternalError>()));
    });

    test("Deve throw ResourceExhaustedExternalError se get() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
    });

    test("Deve throw UnauthenticatedExternalError se get() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnauthenticatedExternalError>()));
    });

    test("Deve throw UnavailableExternalError se get() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnavailableExternalError>()));
    });

    test("Deve throw UnexpectedExternalError se get() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
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
  });

  group("getByTag", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final List<WishlistModel> wishlists = ModelFactory.wishlists(withWishes: false);
    final TagModel tag = ModelFactory.tag();
    final List<Map<String, dynamic>> jsonList = wishlists.map((e) => e.toJson()).toList();

    void mockFirebaseException(String code) => firestore.mockQueryGetError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(datas: jsonList, where: true);
      sut = FirebaseWishlistDataSource(firestore: firestore);
    });

    test("Deve chamar GetByTag e retornar os valores com sucesso", () async {
      final List<WishlistModel> wishlistsResponse = await sut.getByTag(tag);
      expect(wishlistsResponse.equals(wishlists), true);
    });

    test("Deve throw AbortedExternalError se get() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.getByTag(tag);
      expect(future, throwsA(isA<AbortedExternalError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.getByTag(tag);
      expect(future, throwsA(isA<AbortedExternalError>()));
    });

    test("Deve throw AlreadyExistsExternalError se get() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<AlreadyExistsExternalError>()));
    });

    test("Deve throw CancelledExternalError se get() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<CancelledExternalError>()));
    });

    test("Deve throw InternalExternalError se get() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<InternalExternalError>()));
    });

    test("Deve throw InvalidArgumentExternalError se get() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<InvalidArgumentExternalError>()));
    });

    test("Deve throw NotFoundExternalError se get() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw PermissionDeniedExternalError se get() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<PermissionDeniedExternalError>()));
    });

    test("Deve throw ResourceExhaustedExternalError se get() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
    });

    test("Deve throw UnauthenticatedExternalError se get() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<UnauthenticatedExternalError>()));
    });

    test("Deve throw UnavailableExternalError se get() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.getByTag(tag);

      expect(future, throwsA(isA<UnavailableExternalError>()));
    });

    test("Deve throw UnexpectedExternalError se get() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.getByTag(tag);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.getByTag(tag);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.getByTag(tag);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.getByTag(tag);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.getByTag(tag);
      expect(future, throwsA(isA<UnexpectedExternalError>()));
    });
  });

  group("create", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final WishlistModel wishlist = ModelFactory.wishlist(withId: false);
    final String wishlistId = faker.guid.guid();
    final Map<String, dynamic> json = wishlist.toJson()..addAll({'id': wishlistId});

    void mockFirebaseException(String code) => firestore.mockAddError(data: json, error: FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(data: json, add: true);
      sut = FirebaseWishlistDataSource(firestore: firestore);
    });

    test("Deve chamar Create e retornar os valores com sucesso", () async {
      final WishlistModel wishResponse = await sut.create(wishlist);
      expect(wishResponse.equals(wishlist.clone(id: wishlistId)), true);
    });

    test("Deve throw AbortedExternalError se add() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.create(wishlist);
      expect(future, throwsA(isA<AbortedExternalError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.create(wishlist);
      expect(future, throwsA(isA<AbortedExternalError>()));
    });

    test("Deve throw AlreadyExistsExternalError se add() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<AlreadyExistsExternalError>()));
    });

    test("Deve throw CancelledExternalError se add() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<CancelledExternalError>()));
    });

    test("Deve throw InternalExternalError se add() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<InternalExternalError>()));
    });

    test("Deve throw InvalidArgumentExternalError se add() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<InvalidArgumentExternalError>()));
    });

    test("Deve throw NotFoundExternalError se add() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw PermissionDeniedExternalError se add() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<PermissionDeniedExternalError>()));
    });

    test("Deve throw ResourceExhaustedExternalError se add() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
    });

    test("Deve throw UnauthenticatedExternalError se add() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<UnauthenticatedExternalError>()));
    });

    test("Deve throw UnavailableExternalError se add() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.create(wishlist);

      expect(future, throwsA(isA<UnavailableExternalError>()));
    });

    test("Deve throw UnexpectedExternalError se add() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.create(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.create(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.create(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.create(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.create(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));
    });
  });

  group("update", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final WishlistModel wishlist = ModelFactory.wishlist();

    void mockFirebaseException(String code) => firestore.mockUpdateError(error: FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(update: true);
      sut = FirebaseWishlistDataSource(firestore: firestore);
    });

    test("Deve chamar Update e retornar os valores com sucesso", () async {
      final WishlistModel wishlistResponse = await sut.update(wishlist);
      expect(wishlistResponse, wishlist);
    });

    test("Deve throw AbortedExternalError se update() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.update(wishlist);
      expect(future, throwsA(isA<AbortedExternalError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.update(wishlist);
      expect(future, throwsA(isA<AbortedExternalError>()));
    });

    test("Deve throw AlreadyExistsExternalError se update() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<AlreadyExistsExternalError>()));
    });

    test("Deve throw CancelledExternalError se update() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<CancelledExternalError>()));
    });

    test("Deve throw InternalExternalError se update() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<InternalExternalError>()));
    });

    test("Deve throw InvalidArgumentExternalError se update() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<InvalidArgumentExternalError>()));
    });

    test("Deve throw NotFoundExternalError se update() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw PermissionDeniedExternalError se update() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<PermissionDeniedExternalError>()));
    });

    test("Deve throw ResourceExhaustedExternalError se update() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
    });

    test("Deve throw UnauthenticatedExternalError se update() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<UnauthenticatedExternalError>()));
    });

    test("Deve throw UnavailableExternalError se update() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.update(wishlist);

      expect(future, throwsA(isA<UnavailableExternalError>()));
    });

    test("Deve throw UnexpectedExternalError se update() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.update(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.update(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.update(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.update(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.update(wishlist);
      expect(future, throwsA(isA<UnexpectedExternalError>()));
    });
  });

  group("delete", () {
    late FirebaseWishlistDataSource sut;
    late FirestoreFirestoreSpy firestore;

    final String wishlistId = faker.guid.guid();

    void mockFirebaseException(String code) => firestore.mockDeleteError(FirebaseException(plugin: "any_plugin", code: code));

    setUp(() {
      firestore = FirestoreFirestoreSpy(delete: true);
      sut = FirebaseWishlistDataSource(firestore: firestore);
    });

    test("Deve chamar Delete com sucesso", () async {
      await sut.delete(wishlistId);
      verify(() => firestore.collection(constantWishlistsReference).doc(wishlistId).delete());
    });

    test("Deve throw AbortedExternalError se delete() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
      mockFirebaseException("ABORTED");
      Future future = sut.delete(wishlistId);
      expect(future, throwsA(isA<AbortedExternalError>()));

      mockFirebaseException("FAILED_PRECONDITION");
      future = sut.delete(wishlistId);
      expect(future, throwsA(isA<AbortedExternalError>()));
    });

    test("Deve throw AlreadyExistsExternalError se delete() retornar FirebaseException com code ALREADY_EXISTS", () {
      mockFirebaseException("ALREADY_EXISTS");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<AlreadyExistsExternalError>()));
    });

    test("Deve throw CancelledExternalError se delete() retornar FirebaseException com code CANCELLED", () {
      mockFirebaseException("CANCELLED");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<CancelledExternalError>()));
    });

    test("Deve throw InternalExternalError se delete() retornar FirebaseException com code INTERNAL", () {
      mockFirebaseException("INTERNAL");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<InternalExternalError>()));
    });

    test("Deve throw InvalidArgumentExternalError se delete() retornar FirebaseException com code INVALID_ARGUMENT", () {
      mockFirebaseException("INVALID_ARGUMENT");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<InvalidArgumentExternalError>()));
    });

    test("Deve throw NotFoundExternalError se delete() retornar FirebaseException com code NOT_FOUND", () {
      mockFirebaseException("NOT_FOUND");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<NotFoundExternalError>()));
    });

    test("Deve throw PermissionDeniedExternalError se delete() retornar FirebaseException com code PERMISSION_DENIED", () {
      mockFirebaseException("PERMISSION_DENIED");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<PermissionDeniedExternalError>()));
    });

    test("Deve throw ResourceExhaustedExternalError se delete() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
      mockFirebaseException("RESOURCE_EXHAUSTED");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
    });

    test("Deve throw UnauthenticatedExternalError se delete() retornar FirebaseException com code UNAUTHENTICATED", () {
      mockFirebaseException("UNAUTHENTICATED");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<UnauthenticatedExternalError>()));
    });

    test("Deve throw UnavailableExternalError se delete() retornar FirebaseException com code UNAVAILABLE", () {
      mockFirebaseException("UNAVAILABLE");
      final Future future = sut.delete(wishlistId);

      expect(future, throwsA(isA<UnavailableExternalError>()));
    });

    test("Deve throw UnexpectedExternalError se delete() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
      mockFirebaseException("DATA_LOSS");
      Future future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("DEADLINE_EXCEEDED");
      future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("OUT_OF_RANGE");
      future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNIMPLEMENTED");
      future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));

      mockFirebaseException("UNKNOWN");
      future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedExternalError>()));
    });
  });
}