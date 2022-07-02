import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/login_params.dart';
import '../helpers/params/new_password_params.dart';

abstract class IUserAccountRepository {
  Future<UserEntity> authWithEmail(LoginParams params);
  Future<UserEntity> signUpWithEmail(UserEntity entity);
  Future<void> sendVerificationEmail(String userId);
  Future<bool> checkEmailVerified(String userId);
  Future<UserEntity?> getUserLogged();
  Future<void> logout();
  Future<UserEntity> getUserAccount(String userId);
  Future<void> updateUserAccount(UserEntity entity);
  Future<void> updatePassword(NewPasswordParams params);
  Future<void> sendCodeUpdatePassword(String email);
}