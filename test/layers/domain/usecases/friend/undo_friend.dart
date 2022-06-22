import 'package:desejando_app/layers/domain/entities/friend_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/friend/undo_friend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../entities/entity_factory.dart';

void main() {
  late UndoFriend sut;
  late FriendRepositorySpy repositorySpy;

  final FriendEntity entity = EntityFactory.friend();

  setUp(() {
    repositorySpy = FriendRepositorySpy.undo();
    sut = UndoFriend(friendRepository: repositorySpy);
  });

  test("Deve chamar addFriend com valores corretos", () async {
    await sut.undo(entity.friendUserId);
    verify(() => repositorySpy.undoFriend(entity.friendUserId));
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockUndoFriendError();

    final Future future = sut.undo(entity.friendUserId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    repositorySpy.mockUndoFriendError(error: NotFoundDomainError());

    final Future future = sut.undo(entity.friendUserId);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}
