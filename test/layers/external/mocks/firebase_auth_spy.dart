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

  void mockSignInWithEmailAndPassword({required String email, required String password, UserCredentialMock? user}) {
    user ??= UserCredentialMock();

    mockSignInWithEmailAndPasswordCall(email: email, password: password).thenAnswer((_) => Future.value(user));
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
  late bool _emailVerified;

  UserMock({bool emailVerified = true}) {
    _emailVerified = emailVerified;
  }

  @override
  String get uid => faker.guid.guid();

  @override
  String? get displayName => faker.person.name();

  @override
  String? get email => faker.internet.email();

  @override
  bool get emailVerified => _emailVerified;

  @override
  String? get phoneNumber => faker.phoneNumber.random.fromPattern(["(##)#####-####"]);

  @override
  String? get photoURL => faker.internet.httpsUrl();
}