import '../../domain/entities/friends_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/friend_params.dart';
import '../../domain/repositories/i_friend_repository.dart';
import '../datasources/i_friend_datasource.dart';
import '../helpers/errors/infra_error.dart';
import '../models/friends_model.dart';
import '../models/user_model.dart';

class FriendRepository implements IFriendRepository {
  final IFriendDataSource friendDataSource;

  FriendRepository({required this.friendDataSource});

  @override
  Future<void> addFriend(FriendParams params) async {
    try {
      await friendDataSource.addFriend(params);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> undoFriend(FriendParams params) async {
    try {
      await friendDataSource.undoFriend(params);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<FriendsEntity> getFriends(String userId) async {
    try {
      final FriendsModel friendsModel = await friendDataSource.getFriends(userId);
      return friendsModel.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<List<UserEntity>> fetchSearchPersons(String name) async {
    try {
      final List<UserModel> friendsModel = await friendDataSource.fetchSearchPersons(name);
      return friendsModel.map((e) => e.toEntity()).toList();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<bool> verifyFriendship(FriendParams params) async {
    try {
      return await friendDataSource.verifyFriendship(params);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }
}
