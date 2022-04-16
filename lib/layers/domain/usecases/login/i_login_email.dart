import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/login_params.dart';

abstract class ILoginEmail {
  Future<UserEntity> auth(LoginParams params);
}