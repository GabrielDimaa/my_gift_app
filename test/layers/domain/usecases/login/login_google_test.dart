import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/login/login_google.dart';

import '../../../infra/repositories/mocks/user_account_repository_spy.dart';
import '../../entities/entity_extension.dart';
import '../../entities/entity_factory.dart';

void main() {
  late LoginGoogle sut;
  late UserAccountRepositorySpy repositorySpy;

  final UserEntity entity = EntityFactory.user();

  setUp(() {
    repositorySpy = UserAccountRepositorySpy(entityResult: entity);
    sut = LoginGoogle(userAccountRepository: repositorySpy);
  });

  setUpAll(() => registerFallbackValue(entity));

  test("Deve chamar auth e retornar um user com sucesso", () async {
    final UserEntity? user = await sut.auth();
    expect(user!.equals(entity), true);
  });

  test("Deve chamar auth e retornar um user com sucesso", () async {
    repositorySpy.mockAuthWithGoogle(null);

    final UserEntity? user = await sut.auth();
    expect(user, null);
  });

  test("Deve throw StandardError", () {
    repositorySpy.mockAuthWithGoogleError(UnexpectedError());

    final Future future = sut.auth();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    repositorySpy.mockAuthWithGoogleError(Exception());

    final Future future = sut.auth();
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw StandardError", () {
    repositorySpy.mockAuthWithGoogleError(StandardError());

    final Future future = sut.auth();
    expect(future, throwsA(isA<StandardError>()));
  });
}