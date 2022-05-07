import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/login_params.dart';

abstract class IUserAccountRepository {
  Future<UserEntity> authWithEmail(LoginParams params);
  Future<UserEntity> signUpWithEmail(UserEntity entity);
}