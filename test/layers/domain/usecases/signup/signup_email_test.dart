import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/signup/signup_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/user_account_repository_spy.dart';

void main() {
  late SignUpEmail sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity userRequest = EntityFactory.user(withId: false);
  final UserEntity userResult = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityRequest: userRequest, entityResult: userResult);
    sut = SignUpEmail(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(userRequest));

  test("Deve chamar signUpWithEmail com valores corretos", () async {
    await sut.signUp(userRequest);

    verify(() => userAccountRepositorySpy.signUpWithEmail(userRequest));
  });

  test("Deve retornar UserEntity com sucesso", () async {
    final UserEntity user = await sut.signUp(userRequest);

    expect(user, userResult);
  });

  test("Deve throw StandardError se senha não conter pelo menos 8 caracteres", () {
    var userRequestLocal = userRequest;
    final Future future = sut.signUp(userRequestLocal..password = "12345");

    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw UnexpectedError se ocorrer um erro inesperado", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(UnexpectedError());
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(StandardError());
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(Exception());
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<Exception>()));
  });
}