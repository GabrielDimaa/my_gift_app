import 'package:desejando_app/layers/domain/entities/user_entity.dart';

abstract class IGetUserLogged {
  Future<UserEntity?> getUser();
}