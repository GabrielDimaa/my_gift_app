import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class FirestoreFirestoreSpy extends Mock implements FirebaseFirestore {
  late CollectionReferenceStubby collectionReferenceStubby;
  late DocumentReferenceStubby documentReferenceStubby;
  late DocumentSnapshotSpy documentSnapshotSpy;
  late QuerySnapshotSpy querySnapshotSpy;
  late QueryDocumentSnapshotSpy queryDocumentSnapshotSpy;
  late QuerySpy querySpy;

  FirestoreFirestoreSpy.doc(Map<String, dynamic> data) {
    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby();
    documentSnapshotSpy = DocumentSnapshotSpy(data);

    mockCollection();
    mockDocument();
    mockDocumentSnapshot();
  }

  FirestoreFirestoreSpy.where(List<Map<String, dynamic>> datas) {
    collectionReferenceStubby = CollectionReferenceStubby();
    querySpy = QuerySpy();

    mockCollection();
    mockWhere();
    mockQueryGet(QuerySnapshotSpy(datas));
  }

  FirestoreFirestoreSpy.docs(List<Map<String, dynamic>> datas) {
    collectionReferenceStubby = CollectionReferenceStubby();
    querySnapshotSpy = QuerySnapshotSpy(datas);

    mockCollection();
    mockQuerySnapshot();
  }

  FirestoreFirestoreSpy.add(Map<String, dynamic> data) {
    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby(docId: data['id']);
    documentSnapshotSpy = DocumentSnapshotSpy(data);

    mockCollection();
    mockDocument();
    mockAdd(data);
  }

  FirestoreFirestoreSpy.update() {
    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby();

    mockCollection();
    mockDocument();
    mockUpdate();
  }

  FirestoreFirestoreSpy.delete() {
    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby();

    mockCollection();
    mockDocument();
    mockDelete();
  }

  // FirestoreFirestoreSpy.batch() {
  //   collectionReferenceStubby = CollectionReferenceStubby();
  //   documentReferenceStubby = DocumentReferenceStubby();
  //   batchStubby = WriteBatchStubby();
  //
  //   mockCollection();
  //   mockDocumentTeste();
  //   mockBatch();
  //   mockSet();
  //   mockCommit();
  // }

  When _mockCollectionCall() => when(() => collection(any()));
  void mockCollection() => _mockCollectionCall().thenReturn(collectionReferenceStubby);

  //region doc
  When _mockDocumentCall() => when(() => collectionReferenceStubby.doc(any()));
  void mockDocument() => _mockDocumentCall().thenReturn(documentReferenceStubby);

  When _mockDocumentSnapshotCall() => when(() => documentReferenceStubby.get());
  void mockDocumentSnapshot() => _mockDocumentSnapshotCall().thenAnswer((_) => Future.value(documentSnapshotSpy));
  void mockDocumentSnapshotWithParameters(DocumentSnapshotSpy snapshot) => _mockDocumentSnapshotCall().thenAnswer((_) => Future.value(snapshot));
  void mockDocumentSnapshotError(FirebaseException error) => _mockDocumentSnapshotCall().thenThrow(error);
  //endregion

  //region docs
  When _mockQuerySnapshotCall() => when(() => collectionReferenceStubby.get());
  void mockQuerySnapshot({List<Map<String, dynamic>>? datas}) {
    return _mockQuerySnapshotCall().thenAnswer((_) => Future.value(datas != null ? QuerySnapshotSpy(datas) : querySnapshotSpy));
  }
  //endregion

  //region where
  When _mockWhereCall() => when(() => collectionReferenceStubby.where(
    any(),
    isNotEqualTo: any(named: "isNotEqualTo"),
    isNull: any(named: "isNull"),
    isEqualTo: any(named: "isEqualTo"),
    isGreaterThan: any(named: "isGreaterThan"),
    isGreaterThanOrEqualTo: any(named: "isGreaterThanOrEqualTo"),
    isLessThan: any(named: "isLessThan"),
    isLessThanOrEqualTo: any(named: "isLessThanOrEqualTo"),
    arrayContains: any(named: "arrayContains"),
    arrayContainsAny: any(named: "arrayContainsAny"),
    whereIn: any(named: "whereIn"),
    whereNotIn: any(named: "whereNotIn"),
  ));
  void mockWhere() => _mockWhereCall().thenReturn(querySpy);

  When _mockQueryGetCall() => when(() => querySpy.get());
  void mockQueryGet(QuerySnapshotSpy snapshot) => _mockQueryGetCall().thenAnswer((_) => Future.value(snapshot));
  void mockQueryGetError(Exception error) => _mockQueryGetCall().thenThrow(error);
  //endregion

  //region add
  When _mockAddCall(Map<String, dynamic> data) => when(() => collectionReferenceStubby.add(data));
  void mockAdd(Map<String, dynamic> data) => _mockAddCall(data).thenAnswer((_) => Future.value(documentReferenceStubby));
  void mockAddError({required Map<String, dynamic> data, required Exception error}) => _mockAddCall(data).thenThrow(error);
  //endregion

  //region update
  When _mockUpdateCall() => when(() => documentReferenceStubby.update(any()));
  void mockUpdate() => _mockUpdateCall().thenAnswer((_) => Future.value());
  void mockUpdateError({required Exception error}) => _mockUpdateCall().thenThrow(error);
  //endregion

  //region delete
  When _mockDeleteCall() => when(() => documentReferenceStubby.delete());
  void mockDelete() => _mockDeleteCall().thenAnswer((_) => Future.value());
  void mockDeleteError(Exception error) => _mockDeleteCall().thenThrow(error);
  //endregion

  //region batch
  // When _mockBatchCall() => when(() => batch());
  // void mockBatch() => _mockBatchCall().thenReturn(batchStubby);
  //
  // When _mockSetCall() => when(() => batchStubby.set(collectionReferenceStubby.doc(), any()));
  // void mockSet() => _mockSetCall().thenAnswer((_) => Future.value());
  //
  // When _mockCommitCall() => when(() => batchStubby.commit());
  // void mockCommit() => _mockCommitCall().thenAnswer((_) => Future.value());
  //
  // When _mockDocumentTesteCall() => when(() => collectionReferenceStubby.doc());
  // void mockDocumentTeste() => _mockDocumentTesteCall().thenReturn(documentReferenceStubby);
  //endregion
}

// ignore: subtype_of_sealed_class
class CollectionReferenceStubby extends Mock implements CollectionReference<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class DocumentReferenceStubby extends Mock implements DocumentReference<Map<String, dynamic>> {
  final String? docId;

  DocumentReferenceStubby({this.docId});

  @override
  String get id => docId ?? faker.guid.guid();
}
// ignore: subtype_of_sealed_class
class DocumentSnapshotSpy extends Mock implements DocumentSnapshot<Map<String, dynamic>> {
  String? idJson;
  Map<String, dynamic>? json;

  DocumentSnapshotSpy(Map<String, dynamic>? json) {
    idJson = json?['id'];
    this.json = json?..remove('id');
  }

  @override
  Map<String, dynamic>? data() => json;

  @override
  String get id => idJson ?? "";
}
// ignore: subtype_of_sealed_class
class QueryDocumentSnapshotSpy extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {
  late String idJson;
  late Map<String, dynamic> json;

  QueryDocumentSnapshotSpy(Map<String, dynamic> json) {
    idJson = json['id'] ?? "";
    this.json = json..remove('id');
  }

  @override
  Map<String, dynamic> data() => json;

  @override
  String get id => idJson;
}

class QuerySnapshotSpy extends Mock implements QuerySnapshot<Map<String, dynamic>> {
  late List<QueryDocumentSnapshotSpy> docsResults;

  QuerySnapshotSpy(List<Map<String, dynamic>> listJson) {
    docsResults = listJson.map((e) => QueryDocumentSnapshotSpy(e)).toList();
  }

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => docsResults;
}

// ignore: subtype_of_sealed_class
class QuerySpy extends Mock implements Query<Map<String, dynamic>> {}
class WriteBatchStubby extends Mock implements WriteBatch {}