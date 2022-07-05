import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/login/login_email.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/params/login_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../domain/params_factory.dart';
import '../../../infra/repositories/mocks/user_account_repository_spy.dart';

void main() {
  late LoginEmail sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final LoginParams loginParams = ParamsFactory.login();
  final UserEntity userResult = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(params: loginParams, entityResult: userResult);
    sut = LoginEmail(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(userResult));

  test("Deve chamar authWithEmail com valores corretos", () async {
    await sut.auth(loginParams);

    verify(() => userAccountRepositorySpy.authWithEmail(loginParams));
  });

  test("Deve retornar UserEntity com sucesso", () async {
    final UserEntity user = await sut.auth(loginParams);

    expect(user, userResult);
  });

  test("Deve throw EmailError se email não for verificado", () {
    userAccountRepositorySpy.mockAuthWithEmail(EntityFactory.user(emailVerified: false));
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<EmailError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockAuthWithEmailError(UnexpectedError());
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockAuthWithEmailError(Exception());
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockAuthWithEmailError(StandardError());
    final Future future = sut.auth(loginParams);

    expect(future, throwsA(isA<StandardError>()));
  });
}
