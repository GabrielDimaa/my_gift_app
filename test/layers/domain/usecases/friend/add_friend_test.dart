import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/helpers/params/friend_params.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/friend/add_friend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../params_factory.dart';

void main() {
  late AddFriend sut;
  late FriendRepositorySpy repositorySpy;

  final FriendParams params = ParamsFactory.friend();

  setUp(() {
    repositorySpy = FriendRepositorySpy.add();
    sut = AddFriend(friendRepository: repositorySpy);
  });

  setUpAll(() => registerFallbackValue(params));

  test("Deve chamar addFriend com valores corretos", () async {
    await sut.add(params);
    verify(() => repositorySpy.addFriend(params));
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockAddFriendError();

    final Future future = sut.add(params);
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw StandardError", () {
    repositorySpy.mockAddFriendError(error: UnexpectedError());

    Future future = sut.add(params);
    expect(future, throwsA(isA<StandardError>()));

    repositorySpy.mockAddFriendError(error: StandardError());

    future = sut.add(params);
    expect(future, throwsA(isA<StandardError>()));
  });
}
