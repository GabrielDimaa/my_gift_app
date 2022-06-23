import '../../domain/helpers/params/friend_params.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

abstract class IFriendDataSource {
  Future<FriendModel> addFriend(FriendParams params);
  Future<void> undoFriend(String friendUserId, String processorUserId);
  Future<List<FriendModel>> getFriends(String userId);
  Future<List<UserModel>> fetchSearchFriends(String name);
}