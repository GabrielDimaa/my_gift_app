import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/params/new_password_params.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/user/update_password.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';
import '../../params_factory.dart';

void main() {
  late UpdatePassword sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final NewPasswordParams params = ParamsFactory.newPasswordParams();
  final UserEntity entity = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: entity, newPasswordParams: params);
    sut = UpdatePassword(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() {
    registerFallbackValue(entity);
    registerFallbackValue(params);
  });

  test("Deve chamar sendCodeUpdatePassword com valores corretos", () async {
    await sut.update(params);
    verify(() => userAccountRepositorySpy.updatePassword(params));
  });

  test("Deve throw StandardError se a senha for menor que 8 caracteres", () {
    final NewPasswordParams params = NewPasswordParams(code: faker.randomGenerator.string(4, min: 4), newPassword: faker.randomGenerator.string(6));
    final Future future = sut.update(params);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError se ocorrer um erro qualquer", () {
    userAccountRepositorySpy.mockUpdatePasswordError(error: UnexpectedError());

    final Future future = sut.update(params);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockUpdatePasswordError(error: StandardError());

    final Future future = sut.update(params);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockUpdatePasswordError(error: Exception());

    final Future future = sut.update(params);
    expect(future, throwsA(isA<Exception>()));
  });
}
