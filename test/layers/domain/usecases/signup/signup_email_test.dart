import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/errors/domain_error.dart';
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

  test("Deve throw PasswordDomainError se senha não conter pelo menos 8 caracteres", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(PasswordDomainError());
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<PasswordDomainError>()));
  });

  test("Deve throw EmailInvalidDomainError se email for inválido", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(EmailInvalidDomainError());
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<EmailInvalidDomainError>()));
  });

  test("Deve throw EmailInUseDomainError se email já estiver em uso", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(EmailInUseDomainError());
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<EmailInUseDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se ocorrer um erro inesperado", () {
    userAccountRepositorySpy.mockSignUpWithEmailError(UnexpectedDomainError("any_message"));
    final Future future = sut.signUp(userRequest);

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}