import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/signup/send_verification_email.dart';
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

  setUpAll(() => registerFallbackValue(user));

  test("Deve chamar sendVerificationEmail com valores corretos", () async {
    await sut.send(userId);
    verify(() => userAccountRepositorySpy.sendVerificationEmail(userId));
  });

  test("Deve throw EmailError se email for inválido", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(EmailError());

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<EmailError>()));
  });

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(UnexpectedError("any_message"));

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(StandardError());

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockSendVerificationEmailError(Exception());

    final Future future = sut.send(userId);
    expect(future, throwsA(isA<Exception>()));
  });
}