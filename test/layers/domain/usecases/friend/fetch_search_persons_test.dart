import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/friend/fetch_search_persons.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../entities/entity_extension.dart';
import '../../entities/entity_factory.dart';

void main() {
  late FetchSearchPersons sut;
  late FriendRepositorySpy repositorySpy;

  final String name = faker.person.name();
  final List<UserEntity> entities = EntityFactory.users();

  setUp(() {
    repositorySpy = FriendRepositorySpy.search(entities: entities);
    sut = FetchSearchPersons(friendRepository: repositorySpy);
  });

  test("Deve chamar fetchSearchFriends com valores corretos", () async {
    await sut.search(name);
    verify(() => repositorySpy.fetchSearchPersons(name));
  });

  test("Deve chamar fetch e retornar os valores com sucesso", () async {
    final List<UserEntity> users = await sut.search(name);
    expect(users.equals(entities), true);
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockFetchSearchFriendsError();

    final Future future = sut.search(name);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}