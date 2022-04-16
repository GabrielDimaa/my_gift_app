import 'package:desejando_app/layers/data/usecases/login/login_email.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/login_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entity_factory.dart';
import '../../../domain/params_factory.dart';
import '../../../infra/mocks/login_repository_spy.dart';

void main() {
  late LoginEmail sut;
  late LoginRepositorySpy loginRepositorySpy;

  final LoginParams loginParams = ParamsFactory.login();
  final UserEntity userResult = EntityFactory.user();

  setUp(() {
    loginRepositorySpy = LoginRepositorySpy(params: loginParams, entity: userResult);
    sut = LoginEmail(loginRepository: loginRepositorySpy);
  });

  test("Deve chamar authWithEmail com valores corretos", () async {
    await sut.auth(loginParams);

    verify(() => loginRepositorySpy.authWithEmail(loginParams));
  });

  test("Deve retornar UserEntity com sucesso", () async {
    final UserEntity user = await sut.auth(loginParams);

    expect(user, userResult);
  });

  test("Deve throw EmailNotVerifiedDomainError se email não foi verificado", () {
    loginRepositorySpy.mockAuthWithEmail(EntityFactory.user(emailVerified: false));
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<EmailNotVerifiedDomainError>()));
  });
}
