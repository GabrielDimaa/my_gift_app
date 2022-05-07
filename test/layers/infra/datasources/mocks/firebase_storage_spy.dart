import 'package:firebase_storage/firebase_storage.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseStorageSpy extends Mock implements FirebaseStorage {
  late Reference reference;
  late UploadTask uploadTask;
  late TaskSnapshot snapshot;

  //TODO: Finalizar upload de arquivos

  FirebaseStorageSpy({required String url}) {
    reference = ReferenceSpy();
    uploadTask = UploadTaskSpy();
    snapshot = TaskSnapshotSpy();

    mockRef();
    mockChild();
    mockPutFile();
    mockGetDownloadURL(url);
  }

  //ref
  When mockRefCall() => when(() => ref());
  void mockRef() => mockRefCall().thenReturn(reference);
  //endregion

  //child
  When mockChildCall() => when(() => reference.child(any()));
  void mockChild() => mockChildCall().thenReturn(reference);
  //endregion

  //putFile
  When mockPutFileCall() => when(() => reference.putFile(any()));
  void mockPutFile() => mockPutFileCall().thenAnswer((_) => uploadTask);
  //endregion

  //getDownloadURL
  When mockGetDownloadURLCall() => when(() => uploadTask.snapshot.ref.getDownloadURL());
  void mockGetDownloadURL(String url) => mockGetDownloadURLCall().thenAnswer((_) => url);
  //endregion
}

class ReferenceSpy extends Mock implements Reference {}

class UploadTaskSpy extends Mock implements UploadTask {}

class TaskSnapshotSpy extends Mock implements TaskSnapshot {}
