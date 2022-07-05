import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/tag_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/tag/save_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/tag_repository_spy.dart';

void main() {
  late SaveTag sut;
  late TagRepositorySpy tagRepositorySpy;

  group("create", () {
    final TagEntity tagToSaved = EntityFactory.tag(withId: false);
    final TagEntity tagResult = EntityFactory.tag();

    setUp(() {
      tagRepositorySpy = TagRepositorySpy(data: tagResult, save: true);
      sut = SaveTag(tagRepository: tagRepositorySpy);
    });

    setUpAll(() => registerFallbackValue(tagToSaved));

    test("Deve chamar create com valores corretos", () async {
      await sut.save(tagToSaved);
      verify(() => tagRepositorySpy.create(tagToSaved));
    });

    test("Deve chamar create e retornar os valores com sucesso", () async {
      final TagEntity tag = await sut.save(tagToSaved);
      expect(tag.equals(tagResult), true);
      expect(tag.id != null, true);
    });

    test("Deve throw ValidationDomainError se entity.name for vazio", () {
      final Future future = sut.save(EntityFactory.tag()..name = "");
      expect(future, throwsA(isA<RequiredError>()));
    });

    test("Deve throw ValidationDomainError se entity.color for vazio", () {
      final Future future = sut.save(EntityFactory.tag()..color = "");
      expect(future, throwsA(isA<RequiredError>()));
    });

    test("Deve throw StandardError se ocorrer um erro inesperado", () {
      tagRepositorySpy.mockCreateError(error: UnexpectedError());

      final Future future = sut.save(tagToSaved);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      tagRepositorySpy.mockCreateError(error: StandardError());

      final Future future = sut.save(tagToSaved);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      tagRepositorySpy.mockCreateError(error: Exception());

      final Future future = sut.save(tagToSaved);
      expect(future, throwsA(isA<Exception>()));
    });
  });

  group("update", () {
    final TagEntity tagToUpdated = EntityFactory.tag();

    setUp(() {
      tagRepositorySpy = TagRepositorySpy(data: tagToUpdated, save: true);
      sut = SaveTag(tagRepository: tagRepositorySpy);
    });

    setUpAll(() => registerFallbackValue(tagToUpdated));

    test("Deve chamar update com valores corretos", () async {
      await sut.save(tagToUpdated);
      verify(() => tagRepositorySpy.update(tagToUpdated));
    });

    test("Deve chamar update com sucesso", () async {
      final TagEntity tag = await sut.save(tagToUpdated);
      expect(tag.equals(tagToUpdated), true);
    });

    test("Deve throw ValidationDomainError se entity.name for vazio", () {
      final Future future = sut.save(EntityFactory.tag()..name = "");
      expect(future, throwsA(isA<RequiredError>()));
    });

    test("Deve throw ValidationDomainError se entity.color for vazio", () {
      final Future future = sut.save(EntityFactory.tag()..color = "");
      expect(future, throwsA(isA<RequiredError>()));
    });

    test("Deve throw UnexpectedDomainError se ocorrer um erro inesperado", () {
      tagRepositorySpy.mockUpdateError(error: UnexpectedError());

      final Future future = sut.save(tagToUpdated);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      tagRepositorySpy.mockUpdateError(error: StandardError());

      final Future future = sut.save(tagToUpdated);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      tagRepositorySpy.mockUpdateError(error: Exception());

      final Future future = sut.save(tagToUpdated);
      expect(future, throwsA(isA<Exception>()));
    });
  });
}
