import '../../domain/entities/friends_entity.dart';
import 'user_model.dart';

class FriendsModel {
  final List<UserModel> friends;

  FriendsModel({required this.friends});

  FriendsEntity toEntity() => FriendsEntity(friends: friends.map((e) => e.toEntity()).toList());

  factory FriendsModel.fromEntity(FriendsEntity entity) {
    return FriendsModel(
      friends: entity.friends.map((e) => UserModel.fromEntity(e)).toList(),
    );
  }
}
