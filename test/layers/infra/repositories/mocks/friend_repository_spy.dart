import 'package:desejando_app/layers/domain/entities/friend_entity.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/repositories/i_friend_repository.dart';
import 'package:mocktail/mocktail.dart';

class FriendRepositorySpy extends Mock implements IFriendRepository {
  FriendRepositorySpy.add({required FriendEntity friendEntity}) {
    mockAddFriend(friendEntity);
  }

  FriendRepositorySpy.undo() {
    mockUndoFriend();
  }

  FriendRepositorySpy.get({required List<FriendEntity> entities}) {
    mockGetFriends(entities);
  }

  FriendRepositorySpy.search({required List<UserEntity> entities}) {
    mockFetchSearchFriends(entities);
  }

  //region addFriend
  When mockAddFriendCall() => when(() => addFriend(any()));
  void mockAddFriend(FriendEntity entity) => mockAddFriendCall().thenAnswer((_) => Future.value(entity));
  void mockAddFriendError({Exception? error}) => mockAddFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region undoFriend
  When mockUndoFriendCall() => when(() => undoFriend(any(), any()));
  void mockUndoFriend() => mockUndoFriendCall().thenAnswer((_) => Future.value());
  void mockUndoFriendError({Exception? error}) => mockUndoFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getFriends
  When mockGetFriendsCall() => when(() => getFriends(any()));
  void mockGetFriends(List<FriendEntity> entities) => mockGetFriendsCall().thenAnswer((_) => Future.value(entities));
  void mockGetFriendsError({Exception? error}) => mockGetFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region fetchSearchFriends
  When mockFetchSearchFriendsCall() => when(() => fetchSearchFriends(any()));
  void mockFetchSearchFriends(List<UserEntity> entities) => mockFetchSearchFriendsCall().thenAnswer((_) => Future.value(entities));
  void mockFetchSearchFriendsError({Exception? error}) => mockFetchSearchFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
