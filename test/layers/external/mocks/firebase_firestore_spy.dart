import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class FirestoreFirestoreSpy extends Mock implements FirebaseFirestore {
  late CollectionReferenceStubby collectionReferenceStubby;
  late DocumentReferenceStubby documentReferenceStubbyDoc;
  late DocumentReferenceStubby documentReferenceStubbyAdd;
  late DocumentReferenceStubby documentReferenceStubbyUpdate;
  late DocumentReferenceStubby documentReferenceStubbyDelete;
  late DocumentSnapshotSpy documentSnapshotSpyDoc;
  late DocumentSnapshotSpy documentSnapshotSpyAdd;
  late QuerySnapshotSpy querySnapshotSpyDoc;
  late QueryDocumentSnapshotSpy queryDocumentSnapshotSpy;
  late QuerySpy querySpyWhere;

  FirestoreFirestoreSpy({Map<String, dynamic>? data, List<Map<String, dynamic>>? datas, bool doc = false, bool docs = false, bool where = false, bool add = false, bool update = false, bool delete = false}) {
    collectionReferenceStubby = CollectionReferenceStubby();
    mockCollection();

    //region doc
    if (doc) {
      if (data == null) throw Exception("Parâmetro data inválido!");

      documentReferenceStubbyDoc = DocumentReferenceStubby();
      documentSnapshotSpyDoc = DocumentSnapshotSpy(data);

      mockDocument();
      mockDocumentSnapshot();
    }
    //endregion

    //region docs
    if (docs) {
      if (datas == null) throw Exception("Parâmetro datas inválido!");

      querySnapshotSpyDoc = QuerySnapshotSpy(datas);
      mockQuerySnapshot();
    }
    //endregion

    //region where
    if (where) {
      if (datas == null) throw Exception("Parâmetro datas inválido!");

      querySpyWhere = QuerySpy();

      mockWhere();
      mockQueryGet(QuerySnapshotSpy(datas));
    }
    //endregion

    //region add
    if (add) {
      if (data == null) throw Exception("Parâmetro datas inválido!");

      documentReferenceStubbyAdd = DocumentReferenceStubby(docId: data['id']);
      documentSnapshotSpyAdd = DocumentSnapshotSpy(data);

      mockDocumentAdd();
      mockAdd();
    }
    //endregion

    //region update
    if (update) {
      documentReferenceStubbyUpdate = DocumentReferenceStubby();

      mockDocumentUpdate();
      mockUpdate();
    }
    //endregion

    //region delete
    if (delete) {
      documentReferenceStubbyDelete = DocumentReferenceStubby();

      mockDocumentDelete();
      mockDelete();
    }
    //endregion
  }

  When _mockCollectionCall() => when(() => collection(any()));
  void mockCollection() => _mockCollectionCall().thenReturn(collectionReferenceStubby);

  //region doc
  When _mockDocumentCall() => when(() => collectionReferenceStubby.doc(any()));
  void mockDocument() => _mockDocumentCall().thenReturn(documentReferenceStubbyDoc);

  When _mockDocumentSnapshotCall() => when(() => documentReferenceStubbyDoc.get());
  void mockDocumentSnapshot() => _mockDocumentSnapshotCall().thenAnswer((_) => Future.value(documentSnapshotSpyDoc));
  void mockDocumentSnapshotWithParameters(DocumentSnapshotSpy snapshot) => _mockDocumentSnapshotCall().thenAnswer((_) => Future.value(snapshot));
  void mockDocumentSnapshotError(FirebaseException error) => _mockDocumentSnapshotCall().thenThrow(error);
  //endregion

  //region docs
  When _mockQuerySnapshotCall() => when(() => collectionReferenceStubby.get());
  void mockQuerySnapshot({List<Map<String, dynamic>>? datas}) {
    return _mockQuerySnapshotCall().thenAnswer((_) => Future.value(datas != null ? QuerySnapshotSpy(datas) : querySnapshotSpyDoc));
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
  void mockWhere() => _mockWhereCall().thenReturn(querySpyWhere);

  When _mockQueryGetCall() => when(() => querySpyWhere.get());
  void mockQueryGet(QuerySnapshotSpy snapshot) => _mockQueryGetCall().thenAnswer((_) => Future.value(snapshot));
  void mockQueryGetError(Exception error) => _mockQueryGetCall().thenThrow(error);
  //endregion

  //region add
  When _mockAddCall() => when(() => collectionReferenceStubby.add(any()));
  void mockAdd() => _mockAddCall().thenAnswer((_) => Future.value(documentReferenceStubbyAdd));
  void mockAddError({required Map<String, dynamic> data, required Exception error}) => _mockAddCall().thenThrow(error);

  When _mockDocumentAddCall() => when(() => collectionReferenceStubby.doc(any()));
  void mockDocumentAdd() => _mockDocumentAddCall().thenReturn(documentReferenceStubbyAdd);
  //endregion

  //region update
  When _mockUpdateCall() => when(() => documentReferenceStubbyUpdate.update(any()));
  void mockUpdate() => _mockUpdateCall().thenAnswer((_) => Future.value());
  void mockUpdateError({required Exception error}) => _mockUpdateCall().thenThrow(error);

  When _mockDocumentUpdateCall() => when(() => collectionReferenceStubby.doc(any()));
  void mockDocumentUpdate() => _mockDocumentUpdateCall().thenReturn(documentReferenceStubbyUpdate);
  //endregion

  //region delete
  When _mockDeleteCall() => when(() => documentReferenceStubbyDelete.delete());
  void mockDelete() => _mockDeleteCall().thenAnswer((_) => Future.value());
  void mockDeleteError(Exception error) => _mockDeleteCall().thenThrow(error);

  When _mockDocumentDeleteCall() => when(() => collectionReferenceStubby.doc(any()));
  void mockDocumentDelete() => _mockDocumentDeleteCall().thenReturn(documentReferenceStubbyDelete);
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