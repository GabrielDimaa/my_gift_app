import '../../../entities/user_entity.dart';
import '../../../helpers/params/login_params.dart';

abstract class ILoginEmail {
  Future<UserEntity> auth(LoginParams params);
}