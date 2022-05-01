import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:desejando_app/layers/infra/repositories/tag_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../domain/entities/entity_factory.dart';
import '../../external/mocks/firebase_tag_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late TagRepository sut;
  late FirebaseTagDataSourceSpy tagDataSourceSpy;

  group("getAll", () {
    final List<TagModel> tagsResult = ModelFactory.tags();
    final String userId = faker.guid.guid();

    setUp(() {
      tagDataSourceSpy = FirebaseTagDataSourceSpy(datas: tagsResult, get: true);
      sut = TagRepository(tagDataSource: tagDataSourceSpy);
    });

    test("Deve chamar getAll corretamente", () async {
      await sut.getAll(userId);
      verify(() => tagDataSourceSpy.getAll(userId));
    });

    test("Deve chamar getAll e retornar os valores corretamente", () async {
      final List<TagEntity> tags = await sut.getAll(userId);
      expect(tags.equals(tagsResult.map((e) => e.toEntity()).toList()), true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      tagDataSourceSpy.mockGetAllError(error: ConnectionExternalError());
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      tagDataSourceSpy.mockGetAllError(error: Exception());
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("create", () {
    final TagEntity tagToSaved = EntityFactory.tag(withId: false);
    final TagModel tagResult = ModelFactory.tag();

    setUp(() {
      tagDataSourceSpy = FirebaseTagDataSourceSpy(data: tagResult, save: true);
      sut = TagRepository(tagDataSource: tagDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(TagModel.fromEntity(tagToSaved)));

    test("Deve chamar create e retornar dados com sucesso", () async {
      final TagEntity tag = await sut.create(tagToSaved);
      expect(tag.equals(tagResult.toEntity()), true);
      expect(tag.id != null, true);
      expect(!tag.equals(tagToSaved), true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      tagDataSourceSpy.mockCreateError(error: ConnectionExternalError());

      final Future future = sut.create(tagToSaved);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      tagDataSourceSpy.mockCreateError();

      final Future future = sut.create(tagToSaved);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("update", () {
    final TagEntity tagToUpdated = EntityFactory.tag();
    final TagModel tagResult = ModelFactory.tag();

    setUp(() {
      tagDataSourceSpy = FirebaseTagDataSourceSpy(data: tagResult, save: true);
      sut = TagRepository(tagDataSource: tagDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(TagModel.fromEntity(tagToUpdated)));

    test("Deve chamar update e retornar dados com sucesso", () async {
      final TagEntity tag = await sut.update(tagToUpdated);
      expect(tag.equals(tagResult.toEntity()), true);
      expect(tag.id != null, true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      tagDataSourceSpy.mockUpdateError(error: ConnectionExternalError());

      final Future future = sut.update(tagToUpdated);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      tagDataSourceSpy.mockUpdateError();

      final Future future = sut.update(tagToUpdated);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });
}
