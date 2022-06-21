import '../../domain/helpers/params/login_params.dart';
import '../models/user_model.dart';

abstract class IUserAccountDataSource {
  Future<UserModel> authWithEmail(LoginParams params);
  Future<UserModel> signUpWithEmail(UserModel model);
  Future<void> sendVerificationEmail(String userId);
  Future<bool> checkEmailVerified(String userId);
  Future<UserModel?> getUserLogged();
  Future<UserModel> getById(String userId);
  Future<void> logout();
}