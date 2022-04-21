import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/external/datasources/firebase_user_account_datasource.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/params_factory.dart';
import '../mocks/firebase_auth_spy.dart';

void main() {
  late FirebaseUserAccountDataSource sut;
  late FirebaseAuthSpy firebaseAuthSpy;

  late UserModel userResult;
  late UserMock userFirebase;
  final LoginParams loginParams = ParamsFactory.login();

  void userResultMock() {
    userFirebase = UserMock();
    userResult = UserModel(
      id: userFirebase.uid,
      name: userFirebase.displayName!,
      email: userFirebase.email!,
      phone: userFirebase.phoneNumber!,
      photo: userFirebase.photoURL,
      emailVerified: userFirebase.emailVerified,
    );
  }

  void mockFirebaseException(String code) => firebaseAuthSpy.mockSignInWithEmailAndPasswordError(FirebaseAuthException(code: code));

  setUp(() async {
    firebaseAuthSpy = FirebaseAuthSpy(email: loginParams.email, password: loginParams.password);
    sut = FirebaseUserAccountDataSource(firebaseAuth: firebaseAuthSpy);

    userResultMock();
  });

  test("Deve chamar signInWithEmailAndPassword com valores corretos", () async {
    await sut.authWithEmail(loginParams);
    verify(() => firebaseAuthSpy.signInWithEmailAndPassword(email: loginParams.email, password: loginParams.password));
  });

  test("Deve retornar UserModel com sucesso", () async {
    firebaseAuthSpy.mockSignInWithEmailAndPassword(email: loginParams.email, password: loginParams.password, user: userFirebase);

    final UserModel userResponse = await sut.authWithEmail(loginParams);
    expect(userResponse, userResult);
  });

  test("Deve retornar UserModel com sucesso", () async {
    firebaseAuthSpy.mockSignInWithEmailAndPassword(email: loginParams.email, password: loginParams.password, user: userFirebase);

    final UserModel userResponse = await sut.authWithEmail(loginParams);
    expect(userResponse, userResult);
  });

  test("Deve retornar NotFoundExternalError se signIn retornar credential.user null", () {
    firebaseAuthSpy.mockSignInWithEmailAndPassword(email: loginParams.email, password: loginParams.password, user: null);

    final Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<NotFoundExternalError>()));
  });

  test("Deve retornar NotFoundExternalError se error user-not-found e account-exists-with-different-credential", () {
    mockFirebaseException("user-not-found");
    Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<NotFoundExternalError>()));

    mockFirebaseException("account-exists-with-different-credential");
    future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<NotFoundExternalError>()));
  });

  test("Deve retornar WrongPasswordExternalError se error wrong-password", () {
    mockFirebaseException("wrong-password");
    final Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<WrongPasswordExternalError>()));
  });

  test("Deve retornar EmailInvalidExternalError se error invalid-email", () {
    mockFirebaseException("invalid-email");
    final Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<EmailInvalidExternalError>()));
  });

  test("Deve retornar EmailInUseExternalError se error email-already-in-use", () {
    mockFirebaseException("email-already-in-use");
    final Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<EmailInUseExternalError>()));
  });

  test("Deve retornar NotFoundExternalError se error invalid-credential", () {
    mockFirebaseException("invalid-credential");
    final Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<NotFoundExternalError>()));
  });

  test("Deve retornar InvalidActionExternalError se error invalid-verification-code, invalid-action-code e expired-action-code", () {
    mockFirebaseException("invalid-verification-code");
    Future future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<InvalidActionExternalError>()));

    mockFirebaseException("invalid-action-code");
    future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<InvalidActionExternalError>()));

    mockFirebaseException("expired-action-code");
    future = sut.authWithEmail(loginParams);
    expect(future, throwsA(isA<InvalidActionExternalError>()));
  });
}
