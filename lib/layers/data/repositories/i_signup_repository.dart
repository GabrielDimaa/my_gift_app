import '../../domain/entities/user_entity.dart';

abstract class ISignUpRepository {
  Future<UserEntity> signUpWithEmail(UserEntity entity);
}