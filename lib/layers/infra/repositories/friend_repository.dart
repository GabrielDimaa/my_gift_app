import '../../domain/entities/friends_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/friend_params.dart';
import '../../domain/repositories/i_friend_repository.dart';
import '../datasources/i_friend_datasource.dart';
import '../models/friends_model.dart';
import '../models/user_model.dart';

class FriendRepository implements IFriendRepository {
  final IFriendDataSource friendDataSource;

  FriendRepository({required this.friendDataSource});

  @override
  Future<void> addFriend(FriendParams params) async {
    await friendDataSource.addFriend(params);
  }

  @override
  Future<void> undoFriend(FriendParams params) async {
    await friendDataSource.undoFriend(params);
  }

  @override
  Future<FriendsEntity> getFriends(String userId) async {
    final FriendsModel friendsModel = await friendDataSource.getFriends(userId);
    return friendsModel.toEntity();
  }

  @override
  Future<List<UserEntity>> fetchSearchPersons(String name) async {
    final List<UserModel> friendsModel = await friendDataSource.fetchSearchPersons(name);
    return friendsModel.map((e) => e.toEntity()).toList();
  }

  @override
  Future<bool> verifyFriendship(FriendParams params) async {
    return await friendDataSource.verifyFriendship(params);
  }
}
