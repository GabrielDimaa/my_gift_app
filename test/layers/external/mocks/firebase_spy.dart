import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

class FirestoreSpy extends Mock implements FirebaseFirestore {
  late CollectionReferenceStubby collectionReferenceStubby;
  late DocumentReferenceStubby documentReferenceStubby;
  late DocumentSnapshotSpy documentSnapshotSpy;

  FirestoreSpy(Map<String, dynamic> data) {
    collectionReferenceStubby = CollectionReferenceStubby();
    documentReferenceStubby = DocumentReferenceStubby();
    documentSnapshotSpy = DocumentSnapshotSpy();

    mockCollection();
    mockDocument();
    mockSnapshot();
    mockData(data);
  }

  When _mockCollectionCall() => when(() => collection(any()));
  When _mockDocumentCall() => when(() => collectionReferenceStubby.doc(any()));
  When _mockSnapshotCall() => when(() => documentReferenceStubby.get());
  When _mockDataCall() => when(() => documentSnapshotSpy.data());

  void mockCollection() => _mockCollectionCall().thenReturn(collectionReferenceStubby);
  void mockDocument() => _mockDocumentCall().thenReturn(documentReferenceStubby);
  void mockSnapshot() => _mockSnapshotCall().thenAnswer((_) => Future.value(documentSnapshotSpy));
  void mockData(Map<String, dynamic>? data) => _mockDataCall().thenReturn(data);

  void mockSnapshotError(FirebaseException error) => _mockSnapshotCall().thenThrow(error);
}

// ignore: subtype_of_sealed_class
class CollectionReferenceStubby extends Mock implements CollectionReference<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class DocumentReferenceStubby extends Mock implements DocumentReference<Map<String, dynamic>> {}
// ignore: subtype_of_sealed_class
class DocumentSnapshotSpy extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}