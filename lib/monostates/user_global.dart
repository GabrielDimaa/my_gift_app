import '../layers/domain/entities/user_entity.dart';

class UserGlobal {
  static UserEntity? _user;

  UserEntity? getUser() => _user;
  void setUser(UserEntity? value) => _user = value;
}