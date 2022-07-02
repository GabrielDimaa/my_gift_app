import '../../../helpers/params/new_password_params.dart';

abstract class IUpdatePassword {
  Future<void> update(NewPasswordParams params);
}
