import 'package:desejando_app/layers/data/usecases/signup/signup_email.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entity_factory.dart';
import '../../../infra/mocks/signup_repository_spy.dart';

void main() {
  late SignUpEmail sut;
  late SignUpRepositorySpy signUpRepositorySpy;

  final UserEntity userRequest = EntityFactory.userWithoutId();
  final UserEntity userResult = EntityFactory.user();

  setUp(() {
    signUpRepositorySpy = SignUpRepositorySpy(entityRequest: userRequest, entityResult: userResult);
    sut = SignUpEmail(signUpRepository: signUpRepositorySpy);
  });

  test("Deve chamar signUpWithEmail com valores corretos", () async {
    await sut.auth(userRequest);

    verify(() => signUpRepositorySpy.signUpWithEmail(userRequest));
  });

  test("Deve retornar UserEntity com sucesso", () async {
    final UserEntity user = await sut.auth(userRequest);

    expect(user, userResult);
  });

  test("Deve throw PasswordDomainError se senha não conter pelo menos 8 caracteres", () {
    signUpRepositorySpy.mockSignUpWithEmailError(PasswordDomainError());
    final Future future = sut.auth(userRequest);

    expect(future, throwsA(isA<PasswordDomainError>()));
  });

  test("Deve throw EmailInvalidDomainError se email for inválido", () {
    signUpRepositorySpy.mockSignUpWithEmailError(EmailInvalidDomainError());
    final Future future = sut.auth(userRequest);

    expect(future, throwsA(isA<EmailInvalidDomainError>()));
  });

  test("Deve throw EmailInUseDomainError se email já estiver em uso", () {
    signUpRepositorySpy.mockSignUpWithEmailError(EmailInUseDomainError());
    final Future future = sut.auth(userRequest);

    expect(future, throwsA(isA<EmailInUseDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se ocorrer um erro inesperado", () {
    signUpRepositorySpy.mockSignUpWithEmailError(UnexpectedDomainError("any_message"));
    final Future future = sut.auth(userRequest);

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}