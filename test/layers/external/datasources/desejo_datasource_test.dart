import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desejando_app/layers/external/datasources/firebase_desejo_datasource.dart';
import 'package:desejando_app/layers/external/helpers/external_error.dart';
import 'package:desejando_app/layers/infra/models/desejo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/desejos/mock_desejo.dart';

class FirestoreSpy extends Mock implements FirebaseFirestore {}
// ignore: subtype_of_sealed_class
class CollectionReferenceStubby extends Mock implements CollectionReference<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class DocumentReferenceStubby extends Mock implements DocumentReference<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class DocumentSnapshotSpy extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late FirebaseDesejoDataSource sut;
  late FirestoreSpy firestore;
  late CollectionReferenceStubby collectionReferenceStubby;
  late DocumentReferenceStubby documentReferenceStubby;
  late DocumentSnapshotSpy documentSnapshotSpy;

  late DesejoModel desejo;
  late Map<String, dynamic> json;

  void mockCollection() => when(() => firestore.collection(any())).thenReturn(collectionReferenceStubby);
  void mockDocument() => when(() => collectionReferenceStubby.doc(any())).thenReturn(documentReferenceStubby);
  void mockSnapshot() => when(() => documentReferenceStubby.get()).thenAnswer((_) => Future.value(documentSnapshotSpy));
  void mockData() => when(() => documentSnapshotSpy.data()).thenReturn(json);

  FirebaseException firebaseException(String code) => FirebaseException(plugin: "any_plugin", code: code);

  void initializeMocks() {
    mockCollection();
    mockDocument();
    mockSnapshot();
    mockData();
  }

  setUp(() async {
    firestore = FirestoreSpy();
    sut = FirebaseDesejoDataSource(firestore: firestore);

    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby();
    documentSnapshotSpy = DocumentSnapshotSpy();

    desejo = MockDesejo.desejoModel();
    json = desejo.toJson()..remove('id');

    initializeMocks();
  });

  test("Deve chamar GetById e retornar os valores com sucesso", () async {
    final DesejoModel desejoResponse = await sut.getById(desejo.id);

    expect(desejoResponse, desejo);
  });

  test("Deve throw NotFoundExternalError se data() retornar null", () {
    when(() => documentSnapshotSpy.data()).thenReturn(null);

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<NotFoundExternalError>()));
  });

  test("Deve throw AbortedExternalError se get() retornar FirebaseException com code ABORTED e FAILED_PRECONDITION", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("ABORTED"));
    Future future = sut.getById(desejo.id);
    expect(future, throwsA(isA<AbortedExternalError>()));

    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("FAILED_PRECONDITION"));
    future = sut.getById(desejo.id);
    expect(future, throwsA(isA<AbortedExternalError>()));
  });

  test("Deve throw AlreadyExistsExternalError se get() retornar FirebaseException com code ALREADY_EXISTS", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("ALREADY_EXISTS"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<AlreadyExistsExternalError>()));
  });

  test("Deve throw CancelledExternalError se get() retornar FirebaseException com code CANCELLED", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("CANCELLED"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<CancelledExternalError>()));
  });

  test("Deve throw InternalExternalError se get() retornar FirebaseException com code INTERNAL", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("INTERNAL"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<InternalExternalError>()));
  });

  test("Deve throw InvalidArgumentExternalError se get() retornar FirebaseException com code INVALID_ARGUMENT", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("INVALID_ARGUMENT"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<InvalidArgumentExternalError>()));
  });

  test("Deve throw NotFoundExternalError se get() retornar FirebaseException com code NOT_FOUND", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("NOT_FOUND"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<NotFoundExternalError>()));
  });

  test("Deve throw PermissionDeniedExternalError se get() retornar FirebaseException com code PERMISSION_DENIED", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("PERMISSION_DENIED"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<PermissionDeniedExternalError>()));
  });

  test("Deve throw ResourceExhaustedExternalError se get() retornar FirebaseException com code RESOURCE_EXHAUSTED", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("RESOURCE_EXHAUSTED"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<ResourceExhaustedExternalError>()));
  });

  test("Deve throw UnauthenticatedExternalError se get() retornar FirebaseException com code UNAUTHENTICATED", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("UNAUTHENTICATED"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<UnauthenticatedExternalError>()));
  });

  test("Deve throw UnavailableExternalError se get() retornar FirebaseException com code UNAVAILABLE", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("UNAVAILABLE"));

    final Future future = sut.getById(desejo.id);

    expect(future, throwsA(isA<UnavailableExternalError>()));
  });

  test("Deve throw UnexpectedExternalError se get() retornar FirebaseException com code DATA_LOSS, DEADLINE_EXCEEDED, OUT_OF_RANGE, UNIMPLEMENTED e UNKNOWN", () {
    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("DATA_LOSS"));
    Future future = sut.getById(desejo.id);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("DEADLINE_EXCEEDED"));
    future = sut.getById(desejo.id);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("OUT_OF_RANGE"));
    future = sut.getById(desejo.id);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("UNIMPLEMENTED"));
    future = sut.getById(desejo.id);
    expect(future, throwsA(isA<UnexpectedExternalError>()));

    when(() => documentReferenceStubby.get()).thenThrow(firebaseException("UNKNOWN"));
    future = sut.getById(desejo.id);
    expect(future, throwsA(isA<UnexpectedExternalError>()));
  });
}