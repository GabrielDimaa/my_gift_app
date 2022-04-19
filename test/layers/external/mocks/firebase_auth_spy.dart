import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseAuthSpy extends Mock implements FirebaseAuth {
  final String email;
  final String password;

  FirebaseAuthSpy({required this.email, required this.password}) {
    mockSignInWithEmailAndPassword(email: email, password: password);
  }

  When mockSignInWithEmailAndPasswordCall({String? email, String? password}) {
    return when(() => signInWithEmailAndPassword(email: email ?? this.email, password: password ?? this.password));
  }

  void mockSignInWithEmailAndPassword({required String email, required String password, UserMock? user}) {
    mockSignInWithEmailAndPasswordCall(email: email, password: password).thenAnswer((_) => Future.value(UserCredentialMock(userMock: user)));
  }

  void mockSignInWithEmailAndPasswordError(Exception error) {
    mockSignInWithEmailAndPasswordCall(email: email, password: password).thenThrow(error);
  }
}

class UserCredentialMock extends Mock implements UserCredential {
  late User _userMock;

  UserCredentialMock({User? userMock}) {
    _userMock = userMock ?? UserMock();
  }

  @override
  User? get user => _userMock;
}

class UserMock extends Mock implements User {
  late String _uid;
  late String _displayName;
  late String _email;
  late bool _emailVerified;
  late String _phoneNumber;
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
    _phoneNumber = phoneNumber ?? faker.phoneNumber.random.fromPattern(["(##)#####-####"]);
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
  String? get phoneNumber => _phoneNumber;

  @override
  String? get photoURL => _photoURL;
}
