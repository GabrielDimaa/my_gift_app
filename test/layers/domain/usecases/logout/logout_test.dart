import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/logout/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late Logout sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity entity = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: entity);
    sut = Logout(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(entity));

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