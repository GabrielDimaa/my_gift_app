import '../../../entities/user_entity.dart';

abstract class ISearchFriends {
  Future<List<UserEntity>> fetch(String name);
}