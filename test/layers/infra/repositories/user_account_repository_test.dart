import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/repositories/user_account_repository.dart';
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

  setUp(() {
    userAccountDataSourceSpy = FirebaseUserAccountDataSourceSpy(userModel);
    sut = UserAccountRepository(userAccountDataSource: userAccountDataSourceSpy);
  });

  setUpAll(() {
    registerFallbackValue(loginParams);
    registerFallbackValue(userModel);
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

    test("Deve throw NotFoundDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(NotFoundInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });

    test("Deve throw PasswordDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(WrongPasswordInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<PasswordDomainError>()));
    });

    test("Deve throw EmailNotVerifiedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(EmailNotVerifiedInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<EmailNotVerifiedDomainError>()));
    });

    test("Deve throw EmailInvalidDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(EmailInvalidInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<EmailInvalidDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(UnexpectedInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(ConnectionInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se CancelledInfraError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(CancelledInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se InternalInfraError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(InternalInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("signUpWithEmail", () {
    test("Deve retornar UserEntity com sucesso", () async {
      final UserEntity entity = await sut.signUpWithEmail(userModel.toEntity());
      expect(entity.equals(userModel.toEntity()), true);
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(UnexpectedInfraError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(ConnectionInfraError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(InternalInfraError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw EmailInvalidDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(EmailInvalidInfraError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<EmailInvalidDomainError>()));
    });

    test("Deve throw EmailInUseDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(EmailInUseInfraError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<EmailInUseDomainError>()));
    });

    test("Deve throw PasswordDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(WrongPasswordInfraError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<PasswordDomainError>()));
    });
  });

  group("sendVerificationEmail", () {
    test("Deve chamar sendVerificationEmail com valores corretos", () async {
      await sut.sendVerificationEmail(userId);
      verify(() => userAccountDataSourceSpy.sendVerificationEmail(userId));
    });

    test("Deve throw sendVerificationEmail", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(NotFoundInfraError());
      final Future future = sut.sendVerificationEmail(userId);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(UnexpectedInfraError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(ConnectionInfraError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se CancelledInfraError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(CancelledInfraError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se InternalInfraError", () {
      userAccountDataSourceSpy.mockSendVerificationEmailError(InternalInfraError());

      final Future future = sut.sendVerificationEmail(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("checkEmailVerified", () {
    test("Deve chamar sendVerificationEmail com valores corretos", () async {
      await sut.checkEmailVerified(userId);
      verify(() => userAccountDataSourceSpy.checkEmailVerified(userId));
    });

    test("Deve throw sendVerificationEmail", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(NotFoundInfraError());
      final Future future = sut.checkEmailVerified(userId);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(UnexpectedInfraError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(ConnectionInfraError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se CancelledInfraError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(CancelledInfraError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se InternalInfraError", () {
      userAccountDataSourceSpy.mockCheckEmailVerifiedError(InternalInfraError());

      final Future future = sut.checkEmailVerified(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
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

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockGetUserLoggedError(Exception());

      final Future future = sut.getUserLogged();
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });
}
