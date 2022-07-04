import 'package:my_gift_app/layers/domain/entities/friends_entity.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/repositories/i_friend_repository.dart';
import 'package:mocktail/mocktail.dart';

class FriendRepositorySpy extends Mock implements IFriendRepository {
  FriendRepositorySpy.add() {
    mockAddFriend();
  }

  FriendRepositorySpy.undo() {
    mockUndoFriend();
  }

  FriendRepositorySpy.get({required FriendsEntity entity}) {
    mockGetFriends(entity);
  }

  FriendRepositorySpy.search({required List<UserEntity> entities}) {
    mockFetchSearchFriends(entities);
  }

  FriendRepositorySpy.verify({required bool verified}) {
    mockVerifyFriendship(verified);
  }

  //region addFriend
  When mockAddFriendCall() => when(() => addFriend(any()));
  void mockAddFriend() => mockAddFriendCall().thenAnswer((_) => Future.value());
  void mockAddFriendError({Exception? error}) => mockAddFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region undoFriend
  When mockUndoFriendCall() => when(() => undoFriend(any()));
  void mockUndoFriend() => mockUndoFriendCall().thenAnswer((_) => Future.value());
  void mockUndoFriendError({Exception? error}) => mockUndoFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getFriends
  When mockGetFriendsCall() => when(() => getFriends(any()));
  void mockGetFriends(FriendsEntity entity) => mockGetFriendsCall().thenAnswer((_) => Future.value(entity));
  void mockGetFriendsError({Exception? error}) => mockGetFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region fetchSearchFriends
  When mockFetchSearchFriendsCall() => when(() => fetchSearchPersons(any()));
  void mockFetchSearchFriends(List<UserEntity> entities) => mockFetchSearchFriendsCall().thenAnswer((_) => Future.value(entities));
  void mockFetchSearchFriendsError({Exception? error}) => mockFetchSearchFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region verifyFriendship
  When mockVerifyFriendshipCall() => when(() => verifyFriendship(any()));
  void mockVerifyFriendship(bool value) => mockVerifyFriendshipCall().thenAnswer((_) => Future.value(value));
  void mockVerifyFriendshipError({Exception? error}) => mockVerifyFriendshipCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
