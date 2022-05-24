import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/infra/datasources/firebase_user_account_datasource.dart';
import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/params_factory.dart';
import '../../infra/models/model_factory.dart';
import 'mocks/firebase_auth_spy.dart';

void main() {
  group("authWithEmail", () {
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
      expect(userResponse.id, userResult.id);
      expect(userResponse.email, userResult.email);
    });

    test("Deve retornar NotFoundInfraError se signIn retornar credential.user null", () {
      firebaseAuthSpy.mockSignInWithEmailAndPassword(email: loginParams.email, password: loginParams.password, user: null);

      final Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve retornar NotFoundInfraError se error user-not-found e account-exists-with-different-credential", () {
      mockFirebaseException("user-not-found");
      Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<NotFoundInfraError>()));

      mockFirebaseException("account-exists-with-different-credential");
      future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve retornar WrongPasswordInfraError se error wrong-password", () {
      mockFirebaseException("wrong-password");
      final Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<WrongPasswordInfraError>()));
    });

    test("Deve retornar EmailInvalidInfraError se error invalid-email", () {
      mockFirebaseException("invalid-email");
      final Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<EmailInvalidInfraError>()));
    });

    test("Deve retornar EmailInUseInfraError se error email-already-in-use", () {
      mockFirebaseException("email-already-in-use");
      final Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<EmailInUseInfraError>()));
    });

    test("Deve retornar NotFoundInfraError se error invalid-credential", () {
      mockFirebaseException("invalid-credential");
      final Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<NotFoundInfraError>()));
    });

    test("Deve retornar InvalidActionInfraError se error invalid-verification-code, invalid-action-code e expired-action-code", () {
      mockFirebaseException("invalid-verification-code");
      Future future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<InvalidActionInfraError>()));

      mockFirebaseException("invalid-action-code");
      future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<InvalidActionInfraError>()));

      mockFirebaseException("expired-action-code");
      future = sut.authWithEmail(loginParams);
      expect(future, throwsA(isA<InvalidActionInfraError>()));
    });
  });

  group("signUpWithEmail", () {
    late FirebaseUserAccountDataSource sut;
    late FirebaseAuthSpy firebaseAuthSpy;

    final UserModel userRequest = ModelFactory.user(withId: false);
    // late UserModel userResult;
    // late UserMock userFirebase;

    // void userResultMock() {
    //   userFirebase = UserMock();
    //   userResult = UserModel(
    //     id: userFirebase.uid,
    //     name: userFirebase.displayName!,
    //     email: userFirebase.email!,
    //     photo: userFirebase.photoURL,
    //     emailVerified: userFirebase.emailVerified,
    //   );
    // }

    void mockFirebaseException(String code) => firebaseAuthSpy.mockCreateUserWithEmailAndPasswordError(FirebaseAuthException(code: code));

    setUp(() async {
      firebaseAuthSpy = FirebaseAuthSpy(email: userRequest.email, password: userRequest.password!);
      sut = FirebaseUserAccountDataSource(firebaseAuth: firebaseAuthSpy);

      //userResultMock();
    });

    // TODO: Comentado pq foi alterado o datasource e não foi implementado os mocks necessários
    // test("Deve chamar createUserWithEmailAndPassword com valores corretos", () async {
    //   firebaseAuthSpy.mockCreateUserWithEmailAndPassword(email: userRequest.email, password: userRequest.password!, user: userFirebase);
    //
    //   await sut.signUpWithEmail(userRequest);
    //   verify(() => firebaseAuthSpy.createUserWithEmtest("Deve retornar UserModel com sucesso", () async {
    //     //   firebaseAuthSpy.mockCreateUserWithEmailAndPassword(email: userRequest.email, password: userRequest.password!, user: userFirebase);
    //     //
    //     //   final UserModel userResponse = await sut.signUpWithEmail(userRequest);
    //     //   expect(userResponse.id, userResult.id);
    //     //   expect(userResponse.email, userResult.email);
    //     // });ailAndPassword(email: userRequest.email, password: userRequest.password!));
    // });

    // TODO: Comentado pq foi alterado o datasource e não foi implementado os mocks necessários
    // test("Deve retornar UserModel com sucesso", () async {
    //   firebaseAuthSpy.mockCreateUserWithEmailAndPassword(email: userRequest.email, password: userRequest.password!, user: userFirebase);
    //
    //   final UserModel userResponse = await sut.signUpWithEmail(userRequest);
    //   expect(userResponse.id, userResult.id);
    //   expect(userResponse.email, userResult.email);
    // });

    test("Deve throw WrongPasswordInfraError se password for igual a null", () {
      final Future future = sut.signUpWithEmail(ModelFactory.user(password: null));
      expect(future, throwsA(isA<WrongPasswordInfraError>()));
    });

    test("Deve throw UnexpectedInfraError se credential.user for igual a null", () {
      firebaseAuthSpy.mockCreateUserWithEmailAndPassword(email: userRequest.email, password: userRequest.password!);

      final Future future = sut.signUpWithEmail(userRequest);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve retornar EmailInvalidInfraError se error invalid-email", () {
      mockFirebaseException("invalid-email");

      final Future future = sut.signUpWithEmail(userRequest);
      expect(future, throwsA(isA<EmailInvalidInfraError>()));
    });

    test("Deve retornar EmailInUseInfraError se error email-already-in-use", () {
      mockFirebaseException("email-already-in-use");

      final Future future = sut.signUpWithEmail(userRequest);
      expect(future, throwsA(isA<EmailInUseInfraError>()));
    });

    test("Deve retornar UnexpectedInfraError se error desconhecido", () {
      mockFirebaseException("any_error");

      final Future future = sut.signUpWithEmail(userRequest);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });
  });
}
