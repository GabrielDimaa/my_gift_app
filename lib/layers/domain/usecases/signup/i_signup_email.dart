import '../../entities/user_entity.dart';

abstract class ISignUpEmail {
  Future<UserEntity> signUp(UserEntity entity);
}