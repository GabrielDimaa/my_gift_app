import '../../../entities/user_entity.dart';

abstract class ISaveUserAccount {
  Future<void> save(UserEntity entity);
}
