import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/signup/check_email_verified.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late CheckEmailVerified sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity user = EntityFactory.user();
  final String userId = user.id!;

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: user);
    sut = CheckEmailVerified(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(user));

  test("Deve chamar sendVerificationEmail com valores corretos", () async {
    await sut.check(userId);
    verify(() => userAccountRepositorySpy.checkEmailVerified(userId));
  });

  test("Deve chamar sendVerificationEmail e retornar valor corretamente", () async {
    bool value = await sut.check(userId);
    expect(value, true);

    userAccountRepositorySpy.mockCheckEmailVerified(false);
    value = await sut.check(userId);
    expect(value, false);
  });

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    userAccountRepositorySpy.mockCheckEmailVerifiedError(UnexpectedError());

    final Future future = sut.check(userId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockCheckEmailVerifiedError(StandardError());

    final Future future = sut.check(userId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockCheckEmailVerifiedError(Exception());

    final Future future = sut.check(userId);
    expect(future, throwsA(isA<Exception>()));
  });
}