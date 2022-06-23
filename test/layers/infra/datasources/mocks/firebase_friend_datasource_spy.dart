import 'package:desejando_app/layers/infra/datasources/i_friend_datasource.dart';
import 'package:desejando_app/layers/infra/models/friend_model.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseFriendDataSourceSpy extends Mock implements IFriendDataSource {
  FirebaseFriendDataSourceSpy.add({required FriendModel model}) {
    mockAddFriend(model);
  }

  FirebaseFriendDataSourceSpy.undo() {
    mockUndoFriend();
  }

  FirebaseFriendDataSourceSpy.get({required List<FriendModel> models}) {
    mockGetFriends(models);
  }

  FirebaseFriendDataSourceSpy.search({required List<UserModel> models}) {
    mockFetchSearchFriends(models);
  }

  //region addFriend
  When mockAddFriendCall() => when(() => addFriend(any()));
  void mockAddFriend(FriendModel model) => mockAddFriendCall().thenAnswer((_) => Future.value(model));
  void mockAddFriendError({Exception? error}) => mockAddFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region undoFriend
  When mockUndoFriendCall() => when(() => undoFriend(any(), any()));
  void mockUndoFriend() => mockUndoFriendCall().thenAnswer((_) => Future.value());
  void mockUndoFriendError({Exception? error}) => mockUndoFriendCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getFriends
  When mockGetFriendsCall() => when(() => getFriends(any()));
  void mockGetFriends(List<FriendModel> models) => mockGetFriendsCall().thenAnswer((_) => Future.value(models));
  void mockGetFriendsError({Exception? error}) => mockGetFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region fetchSearchFriends
  When mockFetchSearchFriendsCall() => when(() => fetchSearchFriends(any()));
  void mockFetchSearchFriends(List<UserModel> models) => mockFetchSearchFriendsCall().thenAnswer((_) => Future.value(models));
  void mockFetchSearchFriendsError({Exception? error}) => mockFetchSearchFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
