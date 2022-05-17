class UserEntity {
  final String? id;
  String name;
  String email;
  String? photo;
  bool emailVerified;
  String? password;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    this.photo,
    required this.emailVerified,
    this.password,
  });
}
