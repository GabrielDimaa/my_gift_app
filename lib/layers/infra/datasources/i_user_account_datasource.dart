import '../../domain/helpers/params/login_params.dart';
import '../../domain/helpers/params/new_password_params.dart';
import '../models/user_model.dart';

abstract class IUserAccountDataSource {
  Future<UserModel> authWithEmail(LoginParams params);
  Future<UserModel> signUpWithEmail(UserModel model);
  Future<UserModel?> authWithGoogle();
  Future<void> sendVerificationEmail(String userId);
  Future<bool> checkEmailVerified(String userId);
  Future<UserModel?> getUserLogged();
  Future<UserModel> getById(String userId);
  Future<void> logout();
  Future<void> updateUserAccount(UserModel model);
  Future<void> sendCodeUpdatePassword(String email);
  Future<void> updatePassword(NewPasswordParams params);
}