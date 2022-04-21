import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/repositories/user_account_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/params_factory.dart';
import '../../external/mocks/firebase_user_account_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late UserAccountRepository sut;
  late FirebaseUserAccountDataSourceSpy userAccountDataSourceSpy;

  final LoginParams loginParams = ParamsFactory.login();
  final UserModel userModel = ModelFactory.user();

  setUp(() {
    userAccountDataSourceSpy = FirebaseUserAccountDataSourceSpy(loginParams, userModel);
    sut = UserAccountRepository(userAccountDataSource: userAccountDataSourceSpy);
  });

  group("authWithEmail", () {
    test("Deve chamar authWithEmail com valores corretos", () async {
      await sut.authWithEmail(loginParams);
      verify(() => userAccountDataSourceSpy.authWithEmail(loginParams));
    });

    test("Deve retornar UserEntity com sucesso", () async {
      final UserEntity entity = await sut.authWithEmail(loginParams);
      expect(entity, userModel.toEntity());
    });

    test("Deve throw NotFoundDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(NotFoundExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });

    test("Deve throw PasswordDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(WrongPasswordExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<PasswordDomainError>()));
    });

    test("Deve throw EmailNotVerifiedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(EmailNotVerifiedExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<EmailNotVerifiedDomainError>()));
    });

    test("Deve throw EmailInvalidDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(EmailInvalidExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<EmailInvalidDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(UnexpectedExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(ConnectionExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(CancelledExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(InternalExternalError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("signUpWithEmail", () {
    test("Deve chamar signUpWithEmail com valores corretos", () async {
      await sut.signUpWithEmail(userModel.toEntity());
      verify(() => userAccountDataSourceSpy.signUpWithEmail(userModel));
    });

    test("Deve retornar UserEntity com sucesso", () async {
      final UserEntity entity = await sut.signUpWithEmail(userModel.toEntity());
      expect(entity, userModel.toEntity());
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(UnexpectedExternalError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(ConnectionExternalError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(InternalExternalError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw EmailInvalidDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(EmailInvalidExternalError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<EmailInvalidDomainError>()));
    });

    test("Deve throw EmailInUseDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(EmailInUseExternalError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<EmailInUseDomainError>()));
    });

    test("Deve throw PasswordDomainError", () {
      userAccountDataSourceSpy.mockSignUpWithEmailError(WrongPasswordExternalError());
      final Future future = sut.signUpWithEmail(userModel.toEntity());

      expect(future, throwsA(isA<PasswordDomainError>()));
    });
  });
}
