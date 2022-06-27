import '../../domain/helpers/params/friend_params.dart';
import '../models/friends_model.dart';
import '../models/user_model.dart';

abstract class IFriendDataSource {
  Future<void> addFriend(FriendParams params);
  Future<void> undoFriend(FriendParams params);
  Future<FriendsModel> getFriends(String userId);
  Future<List<UserModel>> fetchSearchPersons(String name);
  Future<bool> verifyFriendship(FriendParams params);
}