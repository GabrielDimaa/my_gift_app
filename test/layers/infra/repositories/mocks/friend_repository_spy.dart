import 'package:desejando_app/layers/domain/entities/friend_entity.dart';
import 'package:desejando_app/layers/domain/repositories/i_friend_repository.dart';
import 'package:mocktail/mocktail.dart';

class FriendRepositorySpy extends Mock implements IFriendRepository {
  FriendRepositorySpy({required FriendEntity friendEntity}) {
    mockAddFriend(friendEntity);
  }

  //region addFriend
  When mockAddFriendCall() => when(() => addFriend(any()));
  void mockAddFriend(FriendEntity entity) => mockAddFriendCall().thenAnswer((_) => Future.value(entity));
  void mockAddFriendError({Exception? error}) => mockAddFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
