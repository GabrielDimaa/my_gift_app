import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/friends_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/friend/get_friends.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late GetFriends sut;
  late FriendRepositorySpy repositorySpy;

  final String processorUserId = faker.guid.guid();
  final FriendsEntity entity = EntityFactory.friends();

  setUp(() {
    repositorySpy = FriendRepositorySpy.get(entity: entity);
    sut = GetFriends(friendRepository: repositorySpy);
  });

  test("Deve chamar getFriends com valores corretos", () async {
    await sut.get(processorUserId);
    verify(() => repositorySpy.getFriends(processorUserId));
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockGetFriendsError();

    final Future future = sut.get(processorUserId);
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw StandardError", () {
    repositorySpy.mockGetFriendsError(error: UnexpectedError());

    Future future = sut.get(processorUserId);
    expect(future, throwsA(isA<StandardError>()));

    repositorySpy.mockGetFriendsError(error: StandardError());

    future = sut.get(processorUserId);
    expect(future, throwsA(isA<StandardError>()));
  });
}