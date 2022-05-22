import 'package:desejando_app/layers/domain/usecases/implements/signup/check_email_verified.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
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

  test("Deve throw UnexpectedDomainError se ocorrer um erro inesperado", () {
    userAccountRepositorySpy.mockCheckEmailVerifiedError(UnexpectedDomainError("any_message"));

    final Future future = sut.check(userId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    userAccountRepositorySpy.mockCheckEmailVerifiedError(NotFoundDomainError());

    final Future future = sut.check(userId);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}