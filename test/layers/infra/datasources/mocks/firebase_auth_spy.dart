import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseAuthSpy extends Mock implements FirebaseAuth {
  final String email;
  final String password;
  late UserMock userMock;

  FirebaseAuthSpy({required this.email, required this.password}) {
    userMock = UserMock();
    mockSignInWithEmailAndPassword(email: email, password: password, user: userMock);
    mockCreateUserWithEmailAndPassword(email: email, password: password, user: userMock);
  }

  //region signInWithEmailAndPassword
  When mockSignInWithEmailAndPasswordCall({String? email, String? password}) {
    return when(() => signInWithEmailAndPassword(email: email ?? this.email, password: password ?? this.password));
  }

  void mockSignInWithEmailAndPassword({required String email, required String password, UserMock? user}) {
    mockSignInWithEmailAndPasswordCall(email: email, password: password).thenAnswer((_) => Future.value(UserCredentialMock(userMock: user)));
  }

  void mockSignInWithEmailAndPasswordError(Exception error) {
    mockSignInWithEmailAndPasswordCall(email: email, password: password).thenThrow(error);
  }
  //endregion

  //region createUserWithEmailAndPassword
  When mockCreateUserWithEmailAndPasswordCall({String? email, String? password}) {
    return when(() => createUserWithEmailAndPassword(email: email ?? this.email, password: password ?? this.password));
  }

  void mockCreateUserWithEmailAndPassword({required String email, required String password, UserMock? user}) {
    mockCreateUserWithEmailAndPasswordCall(email: email, password: password).thenAnswer((_) => Future.value(UserCredentialMock(userMock: user)));
  }

  void mockCreateUserWithEmailAndPasswordError(Exception error) {
    mockCreateUserWithEmailAndPasswordCall().thenThrow(error);
  }
  //endregion
}

class UserCredentialMock extends Mock implements UserCredential {
  late User? _userMock;

  UserCredentialMock({User? userMock}) {
    _userMock = userMock;
  }

  @override
  User? get user => _userMock;
}

class UserMock extends Mock implements User {
  late String _uid;
  late String _displayName;
  late String _email;
  late bool _emailVerified;
  String? _photoURL;

  UserMock({
    String? uid,
    String? displayName,
    String? email,
    bool? emailVerified,
    String? phoneNumber,
    String? photoURL,
  }) {
    _uid = uid ?? faker.guid.guid();
    _displayName = displayName ?? faker.person.name();
    _email = email ?? faker.internet.email();
    _emailVerified = emailVerified ?? true;
    _photoURL = photoURL ?? faker.internet.httpsUrl();
  }

  @override
  String get uid => _uid;

  @override
  String? get displayName => _displayName;

  @override
  String? get email => _email;

  @override
  bool get emailVerified => _emailVerified;

  @override
  String? get photoURL => _photoURL;

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {
    await Future.value();
  }
}
