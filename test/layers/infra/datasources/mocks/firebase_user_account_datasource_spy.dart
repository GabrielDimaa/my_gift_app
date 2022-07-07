import 'package:my_gift_app/layers/infra/datasources/i_user_account_datasource.dart';
import 'package:my_gift_app/layers/infra/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseUserAccountDataSourceSpy extends Mock implements IUserAccountDataSource {
  final UserModel model;

  FirebaseUserAccountDataSourceSpy(this.model) {
    mockAuthWithEmail(model);
    mockAuthWithGoogle(model);
    mockSignUpWithEmail(model);
    mockSendVerificationEmail();
    mockCheckEmailVerified(true);
    mockGetUserLogged(model);
    mockLogout();
    mockGetById(model);
    mockUpdateUserAccount();
    mockSendCodeUpdatePassword();
    mockUpdatePassword();
  }

  //region authWithEmail
  When mockAuthWithEmailCall() => when(() => authWithEmail(any()));
  void mockAuthWithEmail(UserModel data) => mockAuthWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockAuthWithEmailError(Exception error) => mockAuthWithEmailCall().thenThrow(error);
  //endregion

  //region authWithGoogle
  When mockAuthWithGoogleCall() => when(() => authWithGoogle());
  void mockAuthWithGoogle(UserModel? data) => mockAuthWithGoogleCall().thenAnswer((_) => Future.value(data));
  void mockAuthWithGoogleError(Exception error) => mockAuthWithGoogleCall().thenThrow(error);
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

  //region getUserLogged
  When mockGetUserLoggedCall() => when(() => getUserLogged());
  void mockGetUserLogged(UserModel? data) => mockGetUserLoggedCall().thenAnswer((_) => Future.value(data));
  void mockGetUserLoggedError(Exception error) => mockGetUserLoggedCall().thenThrow(error);
  //endregion

  //region logout
  When mockLogoutCall() => when(() => logout());
  void mockLogout() => mockLogoutCall().thenAnswer((_) => Future.value());
  void mockLogoutError(Exception error) => mockLogoutCall().thenThrow(error);
  //endregion

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(UserModel data) => mockGetByIdCall().thenAnswer((_) => Future.value(data));
  void mockGetByIdError(Exception error) => mockGetByIdCall().thenThrow(error);
  //endregion

  //region updateUserAccount
  When mockUpdateUserAccountCall() => when(() => updateUserAccount(any()));
  void mockUpdateUserAccount() => mockUpdateUserAccountCall().thenAnswer((_) => Future.value());
  void mockUpdateUserAccountError(Exception error) => mockUpdateUserAccountCall().thenThrow(error);
  //endregion

  //region sendCodeUpdatePassword
  When mockSendCodeUpdatePasswordCall() => when(() => sendCodeUpdatePassword(any()));
  void mockSendCodeUpdatePassword() => mockSendCodeUpdatePasswordCall().thenAnswer((_) => Future.value());
  void mockSendCodeUpdatePasswordError(Exception error) => mockSendCodeUpdatePasswordCall().thenThrow(error);
  //endregion

  //region updatePassword
  When mockUpdatePasswordCall() => when(() => updatePassword(any()));
  void mockUpdatePassword() => mockUpdatePasswordCall().thenAnswer((_) => Future.value());
  void mockUpdatePasswordError(Exception error) => mockUpdatePasswordCall().thenThrow(error);
  //endregion
}