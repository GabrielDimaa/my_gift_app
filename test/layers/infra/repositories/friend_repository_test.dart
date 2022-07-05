import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/helpers/params/friend_params.dart';
import 'package:my_gift_app/layers/infra/models/friends_model.dart';
import 'package:my_gift_app/layers/infra/models/user_model.dart';
import 'package:my_gift_app/layers/infra/repositories/friend_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/params_factory.dart';
import '../datasources/mocks/firebase_friend_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late FriendRepository sut;
  late FirebaseFriendDataSourceSpy dataSourceSpy;

  group("addFriend", () {
    final FriendParams params = ParamsFactory.friend();

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.add();
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(params));

    test("Deve chamar addFriend com valores corretos", () async {
      await sut.addFriend(params);
      verify(() => dataSourceSpy.addFriend(params));
    });

    test("Deve throw StandardError", () {
      dataSourceSpy.mockAddFriendError(error: StandardError());

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      dataSourceSpy.mockAddFriendError(error: UnexpectedError());

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockAddFriendError();

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA()));
    });
  });

  group("undoFriend", () {
    final FriendParams params = ParamsFactory.friend();

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.undo();
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(params));

    test("Deve chamar undoFriend com valores corretos", () async {
      await sut.undoFriend(params);
      verify(() => dataSourceSpy.undoFriend(params));
    });

    test("Deve throw StandardError", () {
      dataSourceSpy.mockUndoFriendError(error: StandardError());

      final Future future = sut.undoFriend(params);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      dataSourceSpy.mockUndoFriendError(error: UnexpectedError());

      final Future future = sut.undoFriend(params);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockUndoFriendError();

      final Future future = sut.undoFriend(params);
      expect(future, throwsA(isA()));
    });
  });

  group("getFriends", () {
    final String userId = faker.guid.guid();
    final FriendsModel models = ModelFactory.friends();

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.get(model: models);
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    test("Deve chamar getFriends com valores corretos", () async {
      await sut.getFriends(userId);
      verify(() => dataSourceSpy.getFriends(userId));
    });

    test("Deve throw StandardError", () {
      dataSourceSpy.mockGetFriendsError(error: StandardError());

      final Future future = sut.getFriends(userId);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockGetFriendsError(error: UnexpectedError());

      final Future future = sut.getFriends(userId);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockGetFriendsError();

      final Future future = sut.getFriends(userId);
      expect(future, throwsA(isA()));
    });
  });

  group("fetchSearchPersons", () {
    final String name = faker.person.name();
    final List<UserModel> models = ModelFactory.users();

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.search(models: models);
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    test("Deve chamar fetchSearchFriends com valores corretos", () async {
      await sut.fetchSearchPersons(name);
      verify(() => dataSourceSpy.fetchSearchPersons(name));
    });

    test("Deve throw StandardError", () {
      dataSourceSpy.mockFetchSearchFriendsError(error: StandardError());

      final Future future = sut.fetchSearchPersons(name);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      dataSourceSpy.mockFetchSearchFriendsError(error: UnexpectedError());

      final Future future = sut.fetchSearchPersons(name);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockFetchSearchFriendsError();

      final Future future = sut.fetchSearchPersons(name);
      expect(future, throwsA(isA()));
    });
  });

  group("verifyFriendship", () {
    final FriendParams params = ParamsFactory.friend();
    final bool isFriendship = faker.randomGenerator.boolean();

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.verify(verified: isFriendship);
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(params));

    test("Deve chamar verifyFriendship com valores corretos", () async {
      await sut.verifyFriendship(params);
      verify(() => dataSourceSpy.verifyFriendship(params));
    });

    test("Deve chamar verifyFriendship e retornar os valores com sucesso", () async {
      final bool value = await sut.verifyFriendship(params);
      expect(value, isFriendship);
    });

    test("Deve throw StandardError", () {
      dataSourceSpy.mockVerifyFriendshipError(error: StandardError());

      final Future future = sut.verifyFriendship(params);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      dataSourceSpy.mockVerifyFriendshipError(error: UnexpectedError());

      final Future future = sut.verifyFriendship(params);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockVerifyFriendshipError();

      final Future future = sut.verifyFriendship(params);
      expect(future, throwsA(isA()));
    });
  });
}
