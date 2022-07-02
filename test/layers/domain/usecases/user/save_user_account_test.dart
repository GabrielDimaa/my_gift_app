import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/user/save_user_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late SaveUserAccount sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity entity = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: entity);
    sut = SaveUserAccount(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(entity));

  test("Deve chamar updateUserAccount com valores corretos", () async {
    await sut.save(entity);
    verify(() => userAccountRepositorySpy.updateUserAccount(entity));
  });

  test("Deve throw UnexpectedDomainError", () {
    userAccountRepositorySpy.mockUpdateUserAccountError();

    final Future future = sut.save(entity);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}