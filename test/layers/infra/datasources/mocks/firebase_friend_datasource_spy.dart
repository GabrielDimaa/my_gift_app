import 'package:desejando_app/layers/infra/datasources/i_friend_datasource.dart';
import 'package:desejando_app/layers/infra/models/friends_model.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseFriendDataSourceSpy extends Mock implements IFriendDataSource {
  FirebaseFriendDataSourceSpy.add() {
    mockAddFriend();
  }

  FirebaseFriendDataSourceSpy.undo() {
    mockUndoFriend();
  }

  FirebaseFriendDataSourceSpy.get({required FriendsModel model}) {
    mockGetFriends(model);
  }

  FirebaseFriendDataSourceSpy.search({required List<UserModel> models}) {
    mockFetchSearchFriends(models);
  }

  FirebaseFriendDataSourceSpy.verify({required bool verified}) {
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
  void mockGetFriends(FriendsModel model) => mockGetFriendsCall().thenAnswer((_) => Future.value(model));
  void mockGetFriendsError({Exception? error}) => mockGetFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region fetchSearchFriends
  When mockFetchSearchFriendsCall() => when(() => fetchSearchPersons(any()));
  void mockFetchSearchFriends(List<UserModel> models) => mockFetchSearchFriendsCall().thenAnswer((_) => Future.value(models));
  void mockFetchSearchFriendsError({Exception? error}) => mockFetchSearchFriendsCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region verifyFriendship
  When mockVerifyFriendshipCall() => when(() => verifyFriendship(any()));
  void mockVerifyFriendship(bool value) => mockVerifyFriendshipCall().thenAnswer((_) => Future.value(value));
  void mockVerifyFriendshipError({Exception? error}) => mockVerifyFriendshipCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
