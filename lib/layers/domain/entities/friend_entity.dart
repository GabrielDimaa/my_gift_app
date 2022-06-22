class FriendEntity {
  final String? id;
  final String friendUserId;
  final String processorUserId;
  String? name;
  String? email;
  String? photo;
  bool accepted;

  FriendEntity({
    required this.id,
    required this.friendUserId,
    required this.processorUserId,
    required this.name,
    required this.email,
    this.photo,
    this.accepted = false,
  });
}
