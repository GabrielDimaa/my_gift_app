import '../../domain/entities/friend_entity.dart';

class FriendModel {
  final String? id;
  final String friendUserId;
  final String processorUserId;
  String? name;
  String? email;
  String? photo;
  bool accepted;

  FriendModel({
    required this.id,
    required this.friendUserId,
    required this.processorUserId,
    required this.name,
    required this.email,
    this.photo,
    this.accepted = false,
  });

  FriendEntity toEntity() {
    return FriendEntity(
      id: id,
      friendUserId: friendUserId,
      processorUserId: processorUserId,
      name: name,
      email: email,
      photo: photo,
      accepted: accepted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_user_id': friendUserId,
      'processor_user_id': processorUserId,
      'name': name,
      'email': email,
      'photo': photo,
      'accepted': accepted,
    };
  }

  FriendModel clone({String? id}) {
    return FriendModel(
      id: id ?? this.id,
      friendUserId: friendUserId,
      processorUserId: processorUserId,
      name: name,
      email: email,
      photo: photo,
      accepted: accepted,
    );
  }

  factory FriendModel.fromEntity(FriendEntity entity) {
    return FriendModel(
      id: entity.id,
      friendUserId: entity.friendUserId,
      processorUserId: entity.processorUserId,
      name: entity.name,
      email: entity.email,
      photo: entity.photo,
      accepted: entity.accepted,
    );
  }

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'],
      friendUserId: json['friend_user_id'],
      processorUserId: json['processor_user_id'],
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      accepted: json['accepted'] ?? false,
    );
  }
}
