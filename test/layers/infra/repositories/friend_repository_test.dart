import 'package:desejando_app/layers/domain/entities/friend_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/friend_params.dart';
import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/friend_model.dart';
import 'package:desejando_app/layers/infra/repositories/friend_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../domain/params_factory.dart';
import '../datasources/mocks/firebase_friend_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late FriendRepository sut;
  late FirebaseFriendDataSourceSpy dataSourceSpy;

  group("addFriend", () {
    final FriendParams params = ParamsFactory.friend();
    final FriendModel modelResult = ModelFactory.friend(friendUserId: params.friendUserId, processorUserId: params.processorUserId);

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.add(model: modelResult);
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(params));

    test("Deve chamar addFriend com valores corretos", () async {
      await sut.addFriend(params);
      verify(() => dataSourceSpy.addFriend(params));
    });

    test("Deve chamar addFriend e retornar os valores com sucesso", () async {
      final FriendEntity friend = await sut.addFriend(params);
      expect(friend.equals(modelResult.toEntity()), true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      dataSourceSpy.mockAddFriendError(error: ConnectionInfraError());

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      dataSourceSpy.mockAddFriendError();

      final Future future = sut.addFriend(params);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("undoFriend", () {
    final FriendModel model = ModelFactory.friend();

    setUp(() {
      dataSourceSpy = FirebaseFriendDataSourceSpy.undo();
      sut = FriendRepository(friendDataSource: dataSourceSpy);
    });

    test("Deve chamar undoFriend com valores corretos", () async {
      await sut.undoFriend(model.friendUserId, model.processorUserId);
      verify(() => dataSourceSpy.undoFriend(model.friendUserId, model.processorUserId));
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      dataSourceSpy.mockUndoFriendError(error: ConnectionInfraError());

      final Future future = sut.undoFriend(model.friendUserId, model.processorUserId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      dataSourceSpy.mockUndoFriendError();

      final Future future = sut.undoFriend(model.friendUserId, model.processorUserId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });
}
