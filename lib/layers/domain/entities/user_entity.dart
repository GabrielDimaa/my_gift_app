class UserEntity {
  final String? id;
  String name;
  String email;
  String phone;
  String? photo;
  bool emailVerified;
  String? password;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.emailVerified,
    this.password,
  });
}
