import '../../../entities/user_entity.dart';

abstract class IGetUserLogged {
  Future<UserEntity?> getUser();
}