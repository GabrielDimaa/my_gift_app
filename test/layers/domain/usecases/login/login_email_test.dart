import 'package:desejando_app/layers/domain/usecases/login/login_email.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../domain/params_factory.dart';
import '../../../infra/mocks/user_account_repository_spy.dart';

void main() {
  late LoginEmail sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final LoginParams loginParams = ParamsFactory.login();
  final UserEntity userResult = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(params: loginParams, entityResult: userResult);
    sut = LoginEmail(userAccountRepository: userAccountRepositorySpy);
  });

  test("Deve chamar authWithEmail com valores corretos", () async {
    await sut.auth(loginParams);

    verify(() => userAccountRepositorySpy.authWithEmail(loginParams));
  });

  test("Deve retornar UserEntity com sucesso", () async {
    final UserEntity user = await sut.auth(loginParams);

    expect(user, userResult);
  });

  test("Deve throw EmailNotVerifiedDomainError se email não for verificado", () {
    userAccountRepositorySpy.mockAuthWithEmail(EntityFactory.user(emailVerified: false));
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<EmailNotVerifiedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    userAccountRepositorySpy.mockAuthWithEmailError(NotFoundDomainError(message: "any_message"));
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}