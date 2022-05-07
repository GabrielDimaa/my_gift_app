import 'package:desejando_app/layers/infra/datasources/i_user_account_datasource.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseUserAccountDataSourceSpy extends Mock implements IUserAccountDataSource {
  final UserModel model;

  FirebaseUserAccountDataSourceSpy(this.model) {
    mockAuthWithEmail(model);
    mockSignUpWithEmail(model);
  }

  //region authWithEmail
  When mockAuthWithEmailCall() => when(() => authWithEmail(any()));
  void mockAuthWithEmail(UserModel data) => mockAuthWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockAuthWithEmailError(Exception error) => mockAuthWithEmailCall().thenThrow(error);
  //endregion

  //region signUpWithEmail
  When mockSignUpWithEmailCall() => when(() => signUpWithEmail(any()));
  void mockSignUpWithEmail(UserModel data) => mockSignUpWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockSignUpWithEmailError(Exception error) => mockSignUpWithEmailCall().thenThrow(error);
  //endregion
}