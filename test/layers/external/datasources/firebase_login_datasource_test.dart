import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/external/datasources/firebase_login_datasource.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/params_factory.dart';
import '../mocks/firebase_auth_spy.dart';

void main() {
  late FirebaseLoginDataSource sut;
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

  setUp(() async {
    firebaseAuthSpy = FirebaseAuthSpy(email: loginParams.email, password: loginParams.password);
    sut = FirebaseLoginDataSource(firebaseAuth: firebaseAuthSpy);

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
}
