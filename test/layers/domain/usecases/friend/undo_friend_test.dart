import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/friend_params.dart';
import 'package:desejando_app/layers/domain/usecases/implements/friend/undo_friend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/friend_repository_spy.dart';
import '../../params_factory.dart';

void main() {
  late UndoFriend sut;
  late FriendRepositorySpy repositorySpy;

  final FriendParams params = ParamsFactory.friend();

  setUp(() {
    repositorySpy = FriendRepositorySpy.undo();
    sut = UndoFriend(friendRepository: repositorySpy);
  });

  setUpAll(() => registerFallbackValue(params));

  test("Deve chamar addFriend com valores corretos", () async {
    await sut.undo(params);
    verify(() => repositorySpy.undoFriend(params));
  });

  test("Deve throw UnexpectedDomainError", () {
    repositorySpy.mockUndoFriendError();

    final Future future = sut.undo(params);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    repositorySpy.mockUndoFriendError(error: NotFoundDomainError());

    final Future future = sut.undo(params);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}
