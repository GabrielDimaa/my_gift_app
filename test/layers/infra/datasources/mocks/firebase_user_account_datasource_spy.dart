import 'package:desejando_app/layers/infra/datasources/i_user_account_datasource.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseUserAccountDataSourceSpy extends Mock implements IUserAccountDataSource {
  final UserModel model;

  FirebaseUserAccountDataSourceSpy(this.model) {
    mockAuthWithEmail(model);
    mockSignUpWithEmail(model);
    mockSendVerificationEmail();
    mockCheckEmailVerified(true);
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

  //region sendVerificationEmail
  When mockSendVerificationEmailCall() => when(() => sendVerificationEmail(any()));
  void mockSendVerificationEmail() => mockSendVerificationEmailCall().thenAnswer((_) => Future.value());
  void mockSendVerificationEmailError(Exception error) => mockSendVerificationEmailCall().thenThrow(error);
  //endregion

  //region checkEmailVerified
  When mockCheckEmailVerifiedCall() => when(() => checkEmailVerified(any()));
  void mockCheckEmailVerified(bool data) => mockCheckEmailVerifiedCall().thenAnswer((_) => Future.value(data));
  void mockCheckEmailVerifiedError(Exception error) => mockCheckEmailVerifiedCall().thenThrow(error);
  //endregion
}