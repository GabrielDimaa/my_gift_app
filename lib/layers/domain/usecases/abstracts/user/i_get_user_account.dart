import '../../../entities/user_entity.dart';

abstract class IGetUserAccount {
  Future<UserEntity> get(String userId);
}