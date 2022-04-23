import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

class FirestoreFirestoreSpy extends Mock implements FirebaseFirestore {
  late CollectionReferenceStubby collectionReferenceStubby;
  late DocumentReferenceStubby documentReferenceStubby;
  late DocumentSnapshotSpy documentSnapshotSpy;
  late QuerySnapshotSpy querySnapshotSpy;
  late QueryDocumentSnapshotSpy queryDocumentSnapshotSpy;

  FirestoreFirestoreSpy.doc(Map<String, dynamic> data) {
    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby();
    documentSnapshotSpy = DocumentSnapshotSpy(data);

    mockCollection();
    mockCollection();
    mockDocument();
    mockDocumentSnapshot();
  }

  FirestoreFirestoreSpy.docs(List<Map<String, dynamic>> datas) {
    collectionReferenceStubby = CollectionReferenceStubby();
    querySnapshotSpy = QuerySnapshotSpy(datas);

    mockCollection();
    mockQuerySnapshot();
  }

  When _mockCollectionCall() => when(() => collection(any()));
  When _mockDocumentCall() => when(() => collectionReferenceStubby.doc(any()));
  When _mockDocumentSnapshotCall() => when(() => documentReferenceStubby.get());
  When _mockQuerySnapshotCall() => when(() => collectionReferenceStubby.get());

  void mockCollection() => _mockCollectionCall().thenReturn(collectionReferenceStubby);
  void mockDocument() => _mockDocumentCall().thenReturn(documentReferenceStubby);
  void mockDocumentSnapshot() => _mockDocumentSnapshotCall().thenAnswer((_) => Future.value(documentSnapshotSpy));
  void mockDocumentSnapshotWithParameters(DocumentSnapshotSpy snapshot) => _mockDocumentSnapshotCall().thenAnswer((_) => Future.value(snapshot));
  void mockQuerySnapshot({List<Map<String, dynamic>>? datas}) {
    return _mockQuerySnapshotCall().thenAnswer((_) => Future.value(datas != null ? QuerySnapshotSpy(datas) : querySnapshotSpy));
  }
  void mockDocumentSnapshotError(FirebaseException error) => _mockDocumentSnapshotCall().thenThrow(error);
}

// ignore: subtype_of_sealed_class
class CollectionReferenceStubby extends Mock implements CollectionReference<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class DocumentReferenceStubby extends Mock implements DocumentReference<Map<String, dynamic>> {}
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
    idJson = json['id'];
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