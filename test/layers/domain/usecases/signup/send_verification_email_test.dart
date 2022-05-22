import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/signup/send_verification_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late SendVerificationEmail sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity user = EntityFactory.user();
  final String userId = user.id!;

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: user);
    sut = SendVerificationEmail(userAccountRepository: userAccountRepositorySpy);
  });

  test("Deve chamar sendVerificationEmail com valores corretos", () async {
    await sut.send(userId);
    verify(() => userAccountRepositorySpy.sendVerificationEmail(userId));
  });

  test("Deve throw EmailInvalidDomainError se email for inválido", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(EmailInvalidDomainError());

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<EmailInvalidDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se ocorrer um erro inesperado", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(UnexpectedDomainError("any_message"));

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(NotFoundDomainError());

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}