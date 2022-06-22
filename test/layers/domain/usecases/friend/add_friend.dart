import 'package:desejando_app/layers/domain/entities/friend_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/friend_params.dart';
import 'package:desejando_app/layers/domain/usecases/implements/friend/add_friend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../entities/entity_extension.dart';
import '../../entities/entity_factory.dart';
import '../../params_factory.dart';

void main() {
  late AddFriend sut;
  late FriendRepositorySpy repositorySpy;

  final FriendParams params = ParamsFactory.friend();
  final FriendEntity entity = EntityFactory.friend(friendUserId: params.friendUserId, processorUserId: params.processorUserId);

  setUp(() {
    repositorySpy = FriendRepositorySpy(friendEntity: entity);
    sut = AddFriend(friendRepository: repositorySpy);
  });

  setUpAll(() => registerFallbackValue(params));

  test("Deve chamar addFriend com valores corretos", () async {
    await sut.add(params);
    verify(() => repositorySpy.addFriend(params));
  });

  test("Deve chamar addFriend e retornar o valor com sucesso", () async {
    final FriendEntity friend = await sut.add(params);
    expect(friend.equals(entity), true);
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockAddFriendError();

    final Future future = sut.add(params);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
