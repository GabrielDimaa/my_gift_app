import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/helpers/params/friend_params.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/friend/verify_friendship.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../params_factory.dart';

void main() {
  late VerifyFriendship sut;
  late FriendRepositorySpy repositorySpy;

  final FriendParams params = ParamsFactory.friend();
  final bool isFriendship = faker.randomGenerator.boolean();

  setUp(() {
    repositorySpy = FriendRepositorySpy.verify(verified: isFriendship);
    sut = VerifyFriendship(friendRepository: repositorySpy);
  });

  setUpAll(() => registerFallbackValue(params));

  test("Deve chamar verifyFriendship com valores corretos", () async {
    await sut.verify(params);
    verify(() => repositorySpy.verifyFriendship(params));
  });

  test("Deve chamar verifyFriendship e retornar o valor corretamente", () async {
    final bool value = await sut.verify(params);
    expect(value, isFriendship);
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockVerifyFriendshipError();

    final Future future = sut.verify(params);
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw StandardError", () {
    repositorySpy.mockVerifyFriendshipError(error: UnexpectedError());

    Future future = sut.verify(params);
    expect(future, throwsA(isA<StandardError>()));

    repositorySpy.mockVerifyFriendshipError(error: StandardError());

    future = sut.verify(params);
    expect(future, throwsA(isA<StandardError>()));
  });
}