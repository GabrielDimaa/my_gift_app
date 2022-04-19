import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/infra/datasources/i_login_datasource.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseLoginDataSourceSpy extends Mock implements ILoginDataSource {
  final LoginParams params;

  FirebaseLoginDataSourceSpy(this.params, UserModel model) {
    mockAuthWithEmail(model);
  }

  When mockAuthWithEmailCall() => when(() => authWithEmail(params));
  void mockAuthWithEmail(UserModel data) => mockAuthWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockAuthWithEmailError(Exception error) => mockAuthWithEmailCall().thenThrow(error);
}