import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/params/login_params.dart';
import 'package:my_gift_app/layers/domain/helpers/params/new_password_params.dart';
import 'package:my_gift_app/layers/infra/models/user_model.dart';
import 'package:my_gift_app/layers/infra/repositories/user_account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../domain/params_factory.dart';
import '../datasources/mocks/firebase_user_account_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late UserAccountRepository sut;
  late FirebaseUserAccountDataSourceSpy userAccountDataSourceSpy;

  final LoginParams loginParams = ParamsFactory.login();
  final UserModel userModel = ModelFactory.user();
  final String userId = userModel.id!;
  final NewPasswordParams params = ParamsFactory.newPasswordParams();

  setUp(() {
    userAccountDataSourceSpy = FirebaseUserAccountDataSourceSpy(userModel);
    sut = UserAccountRepository(userAccountDataSource: userAccountDataSourceSpy);
  });

  setUpAll(() {
    registerFallbackValue(loginParams);
    registerFallbackValue(userModel);
    registerFallbackValue(params);
  });

  group("authWithEmail", () {
    test("Deve chamar authWithEmail com valores corretos", () async {
      await sut.authWithEmail(loginParams);
      verify(() => userAccountDataSourceSpy.authWithEmail(loginParams));
    });

    test("Deve retornar UserEntity com sucesso", () async {
      final UserEntity entity = await sut.authWithEmail(loginParams);
      expect(entity.equals(userModel.toEntity()), true);
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(StandardError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(UnexpectedError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw EmailError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(EmailError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<EmailError>()));
    });
  });

  group("signUpWithEmail", () {
    test("Deve retornar UserEntity com sucesso", () async {
      final UserEntity entity = await sut.signUpWithEmail(userModel.toEntity());
      expect(entity.equals(userModel.toEntity()), true);
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(UnexpectedError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(Exception());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA()));
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(StandardError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw EmailInvalidDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(EmailError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<EmailError>()));
    });
  });

  group("sendVerificationEmail", () {
    test("Deve chamar sendVerificationEmail com valores corretos", () async {
      await sut.sendVerificationEmail(userId);
      verify(() => userAccountDataSourceSpy.sendVerificationEmail(userId));
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(UnexpectedError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(Exception());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA()));
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(StandardError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw EmailError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(EmailError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<EmailError>()));
    });
  });

  group("checkEmailVerified", () {
    test("Deve chamar sendVerificationEmail com valores corretos", () async {
      await sut.checkEmailVerified(userId);
      verify(() => userAccountDataSourceSpy.checkEmailVerified(userId));
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(UnexpectedError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(Exception());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA()));
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(StandardError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedDomainError se CancelledInfraError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(EmailError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<EmailError>()));
    });
  });

  group("getUserLogged", () {
    test("Deve chamar getUserLogged e retornar o user com sucesso", () async {
      final UserEntity? user = await sut.getUserLogged();
      expect(user!.equals(userModel.toEntity()), true);
    });

    test("Deve chamar getUserLogged e retornar null", () async {
      userAccountDataSourceSpy.mockGetUserLogged(null);

      final UserEntity? user = await sut.getUserLogged();
      expect(user, null);
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockGetUserLoggedError(UnexpectedError());

      final Future future = sut.getUserLogged();
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockGetUserLoggedError(Exception());

      final Future future = sut.getUserLogged();
      expect(future, throwsA(isA()));
    });
  });

  group("logout", () {
    test("Deve chamar logout com sucesso", () async {
      await sut.logout();
      verify(() => userAccountDataSourceSpy.logout());
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockLogoutError(UnexpectedError());

      final Future future = sut.logout();
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockLogoutError(Exception());

      final Future future = sut.logout();
      expect(future, throwsA(isA<Exception>()));
    });
  });

  group("getUserAccount", () {
    test("Deve chamar getById com sucesso", () async {
      await sut.getUserAccount(userId);
      verify(() => userAccountDataSourceSpy.getById(userId));
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockGetByIdError(UnexpectedError());

      final Future future = sut.getUserAccount(userId);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockGetByIdError(Exception());

      final Future future = sut.getUserAccount(userId);
      expect(future, throwsA(isA<Exception>()));
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockGetByIdError(StandardError());

      final Future future = sut.getUserAccount(userId);
      expect(future, throwsA(isA<StandardError>()));
    });
  });

  group("updateUserAccount", () {
    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockUpdateUserAccountError(UnexpectedError());

      final Future future = sut.updateUserAccount(userModel.toEntity());
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockUpdateUserAccountError(Exception());

      final Future future = sut.updateUserAccount(userModel.toEntity());
      expect(future, throwsA(isA<Exception>()));
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockUpdateUserAccountError(StandardError());

      final Future future = sut.updateUserAccount(userModel.toEntity());
      expect(future, throwsA(isA<StandardError>()));
    });
  });

  group("sendCodeUpdatePassword", () {
    final String email = userModel.email;

    test("Deve chamar getById com sucesso", () async {
      await sut.sendCodeUpdatePassword(userId);
      verify(() => userAccountDataSourceSpy.sendCodeUpdatePassword(userId));
    });

    test("Deve throw UnexpectedError", () {
      userAccountDataSourceSpy.mockSendCodeUpdatePasswordError(UnexpectedError());
      final Future future = sut.sendCodeUpdatePassword(email);

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockSendCodeUpdatePasswordError(Exception());
      final Future future = sut.sendCodeUpdatePassword(email);

      expect(future, throwsA(isA()));
    });

    test("Deve throw StandardError", () {
      userAccountDataSourceSpy.mockSendCodeUpdatePasswordError(StandardError());
      final Future future = sut.sendCodeUpdatePassword(email);

      expect(future, throwsA(isA<StandardError>()));
    });
  });

  group("updatePassword", () {
    test("Deve retornar UserEntity com sucesso", () async {
      await sut.updatePassword(params);
      verify(() => userAccountDataSourceSpy.updatePassword(params));
    });

    test("Deve throw UnexpectedInfraError", () {
      userAccountDataSourceSpy.mockUpdatePasswordError(UnexpectedError());
      final Future future = sut.updatePassword(params);

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      userAccountDataSourceSpy.mockUpdatePasswordError(Exception());
      final Future future = sut.updatePassword(params);

      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockUpdatePasswordError(StandardError());
      final Future future = sut.updatePassword(params);

      expect(future, throwsA(isA<StandardError>()));
    });
  });
}
