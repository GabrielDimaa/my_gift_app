import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/login_params.dart';

abstract class ILoginRepository {
  Future<UserEntity> authWithEmail(LoginParams params);
}