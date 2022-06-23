import '../../domain/entities/friend_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/friend_params.dart';
import '../../domain/repositories/i_friend_repository.dart';
import '../datasources/i_friend_datasource.dart';
import '../helpers/errors/infra_error.dart';
import '../models/friend_model.dart';
import '../models/user_model.dart';

class FriendRepository implements IFriendRepository {
  final IFriendDataSource friendDataSource;

  FriendRepository({required this.friendDataSource});

  @override
  Future<FriendEntity> addFriend(FriendParams params) async {
    try {
      final FriendModel friendModel = await friendDataSource.addFriend(params);
      return friendModel.toEntity();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<void> undoFriend(String friendUserId, String processorUserId) async {
    try {
      await friendDataSource.undoFriend(friendUserId, processorUserId);
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<List<FriendEntity>> getFriends(String processorUserId) async {
    try {
      final List<FriendModel> friendsModel = await friendDataSource.getFriends(processorUserId);
      return friendsModel.map((e) => e.toEntity()).toList();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<List<UserEntity>> fetchSearchFriends(String name) async {
    try {
      final List<UserModel> friendsModel = await friendDataSource.fetchSearchFriends(name);
      return friendsModel.map((e) => e.toEntity()).toList();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }
}
