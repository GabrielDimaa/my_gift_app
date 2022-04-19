import '../../domain/helpers/params/login_params.dart';
import '../models/user_model.dart';

abstract class ILoginDataSource {
  Future<UserModel> authWithEmail(LoginParams params);
}