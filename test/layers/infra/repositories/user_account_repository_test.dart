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

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(ConnectionInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      userAccountDataSourceSpy.mockAuthWithEmailError(CancelledInfraError());
      final Future future = sut.authWithEmail(loginParams);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
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
}
