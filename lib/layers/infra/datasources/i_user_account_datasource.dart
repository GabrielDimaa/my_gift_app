import '../../domain/helpers/params/login_params.dart';
import '../models/user_model.dart';

abstract class IUserAccountDataSource {
  Future<UserModel> authWithEmail(LoginParams params);
  Future<UserModel> signUpWithEmail(UserModel model);
}