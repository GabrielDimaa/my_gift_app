import '../../../entities/user_entity.dart';

abstract class ILoginGoogle {
  Future<UserEntity?> auth();
}
