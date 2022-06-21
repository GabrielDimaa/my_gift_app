import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/logout/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late Logout sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: EntityFactory.user());
    sut = Logout(userAccountRepository: userAccountRepositorySpy);
  });

  test("Deve chamar logout", () async {
    await sut.logout();
    verify(() => userAccountRepositorySpy.logout());
  });

  test("Deve throw UnexpectedDomainError se ocorrer qualquer erro", () {
    userAccountRepositorySpy.mockLogoutError();

    final Future future = sut.logout();
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}