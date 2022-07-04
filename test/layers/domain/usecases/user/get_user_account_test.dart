import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/user/get_user_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_extension.dart';
import '../../entities/entity_factory.dart';

void main() {
  late GetUserAccount sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity entity = EntityFactory.user();
  final String userId = entity.id!;

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: entity);
    sut = GetUserAccount(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(entity));

  test("Deve chamar getUserAccount com valores corretos", () async {
    await sut.get(userId);
    verify(() => userAccountRepositorySpy.getUserAccount(userId));
  });

  test("Deve chamar getUserAccount e retornar o user com sucesso", () async {
    final UserEntity user = await sut.get(userId);
    expect(user.equals(entity), true);
  });

  test("Deve throw UnexpectedDomainError", () {
    userAccountRepositorySpy.mockGetUserAccountError();

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}