import '../../../entities/user_entity.dart';

abstract class ISendCodeUpdatePassword {
  Future<void> send(UserEntity entity);
}
