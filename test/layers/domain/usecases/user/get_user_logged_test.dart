import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/user/get_user_logged.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_extension.dart';
import '../../entities/entity_factory.dart';

void main() {
  late GetUserLogged sut;
  late UserAccountRepositorySpy userAccountRepositorySpy;

  final UserEntity entityResult = EntityFactory.user();

  setUp(() {
    userAccountRepositorySpy = UserAccountRepositorySpy(entityResult: entityResult);
    sut = GetUserLogged(userAccountRepository: userAccountRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(entityResult));

  test("Deve chamar getUser e retornar o user com sucesso", () async {
    final UserEntity? user = await sut.getUser();
    expect(user!.equals(entityResult), true);
  });

  test("Deve chamar getUser e retornar null", () async {
    userAccountRepositorySpy.mockGetUserLogged(null);

    final UserEntity? user = await sut.getUser();
    expect(user, null);
  });

  test("Deve throw StandardError se ocorrer um erro qualquer", () {
    userAccountRepositorySpy.mockGetUserLoggedError(error: UnexpectedError());

    final Future future = sut.getUser();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    userAccountRepositorySpy.mockGetUserLoggedError(error: StandardError());

    final Future future = sut.getUser();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    userAccountRepositorySpy.mockGetUserLoggedError(error: Exception());

    final Future future = sut.getUser();
    expect(future, throwsA(isA<Exception>()));
  });
}