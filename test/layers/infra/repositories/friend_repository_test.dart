import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/friend_params.dart';
import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/friends_model.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/repositories/friend_repository.dart';
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

    test("Deve throw ConnectionInfraError", () {
      dataSourceSpy.mockAddFriendError(error: ConnectionInfraError());

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockAddFriendError(error: UnexpectedInfraError());

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
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

    test("Deve throw ConnectionInfraError", () {
      dataSourceSpy.mockUndoFriendError(error: ConnectionInfraError());

      final Future future = sut.undoFriend(params);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockUndoFriendError(error: UnexpectedInfraError());

      final Future future = sut.undoFriend(params);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
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

    test("Deve throw ConnectionInfraError", () {
      dataSourceSpy.mockGetFriendsError(error: ConnectionInfraError());

      final Future future = sut.getFriends(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockGetFriendsError(error: UnexpectedInfraError());

      final Future future = sut.getFriends(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
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

    test("Deve throw ConnectionInfraError", () {
      dataSourceSpy.mockFetchSearchFriendsError(error: ConnectionInfraError());

      final Future future = sut.fetchSearchPersons(name);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockFetchSearchFriendsError(error: UnexpectedInfraError());

      final Future future = sut.fetchSearchPersons(name);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
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

    test("Deve throw ConnectionInfraError", () {
      dataSourceSpy.mockVerifyFriendshipError(error: ConnectionInfraError());

      final Future future = sut.verifyFriendship(params);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      dataSourceSpy.mockVerifyFriendshipError(error: UnexpectedInfraError());

      final Future future = sut.verifyFriendship(params);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockVerifyFriendshipError();

      final Future future = sut.verifyFriendship(params);
      expect(future, throwsA(isA()));
    });
  });
}
