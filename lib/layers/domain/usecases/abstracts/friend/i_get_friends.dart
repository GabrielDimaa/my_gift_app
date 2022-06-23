import '../../../entities/friend_entity.dart';

abstract class IGetFriends {
  Future<List<FriendEntity>> get(String processorUserId);
}