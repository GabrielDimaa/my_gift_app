import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/user/send_code_update_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late SendCodeUpdatePassword sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity entity = EntityFactory.user();
  final String email = entity.email;

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: entity);
    sut = SendCodeUpdatePassword(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(entity));

  test("Deve chamar sendCodeUpdatePassword com valores corretos", () async {
    await sut.send(email);
    verify(() => userAccountRepositorySpy.sendCodeUpdatePassword(email));
  });

  test("Deve throw StandardError se ocorrer um erro qualquer", () {
    userAccountRepositorySpy.mockSendCodeUpdatePasswordError(error: UnexpectedError());

    final Future future = sut.send(email);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockSendCodeUpdatePasswordError(error: StandardError());

    final Future future = sut.send(email);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockSendCodeUpdatePasswordError(error: Exception());

    final Future future = sut.send(email);
    expect(future, throwsA(isA<Exception>()));
  });
}
