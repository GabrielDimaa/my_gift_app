import '../layers/domain/entities/user_entity.dart';

class UserGlobal {
  static UserEntity? user;

  UserEntity? getUser() => user;
  void setUser(UserEntity? value) => user = value;
}