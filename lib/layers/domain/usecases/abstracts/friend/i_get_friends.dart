import '../../../entities/friends_entity.dart';

abstract class IGetFriends {
  Future<FriendsEntity> get(String userId);
}