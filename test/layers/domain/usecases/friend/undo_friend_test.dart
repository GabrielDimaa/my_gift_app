import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/helpers/params/friend_params.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/friend/undo_friend.dart';
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

  test("Deve throw Exception", () {
    repositorySpy.mockUndoFriendError();

    final Future future = sut.undo(params);
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw StandardError", () {
    repositorySpy.mockUndoFriendError(error: UnexpectedError());

    Future future = sut.undo(params);
    expect(future, throwsA(isA<StandardError>()));

    repositorySpy.mockUndoFriendError(error: StandardError());

    future = sut.undo(params);
    expect(future, throwsA(isA<StandardError>()));
  });
}
