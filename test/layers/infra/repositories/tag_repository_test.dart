import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/tag_entity.dart';
import 'package:my_gift_app/layers/infra/models/tag_model.dart';
import 'package:my_gift_app/layers/infra/repositories/tag_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../domain/entities/entity_factory.dart';
import '../datasources/mocks/firebase_tag_datasource_spy.dart';
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

    test("Deve throw StandardError", () {
      tagDataSourceSpy.mockGetAllError(error: StandardError());
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      tagDataSourceSpy.mockGetAllError();
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedError", () {
      tagDataSourceSpy.mockGetAllError(error: UnexpectedError());
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnexpectedError>()));
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

    test("Deve throw StandardError", () {
      tagDataSourceSpy.mockCreateError(error: StandardError());

      final Future future = sut.create(tagToSaved);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      tagDataSourceSpy.mockCreateError(error: UnexpectedError());

      final Future future = sut.create(tagToSaved);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw StandardError", () {
      tagDataSourceSpy.mockCreateError();

      final Future future = sut.create(tagToSaved);
      expect(future, throwsA(isA()));
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

    test("Deve throw StandardError", () {
      tagDataSourceSpy.mockUpdateError(error: StandardError());

      final Future future = sut.update(tagToUpdated);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      tagDataSourceSpy.mockUpdateError(error: UnexpectedError());

      final Future future = sut.update(tagToUpdated);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      tagDataSourceSpy.mockUpdateError();

      final Future future = sut.update(tagToUpdated);
      expect(future, throwsA(isA()));
    });
  });

  group("delete", () {
    final String tagId = faker.guid.guid();

    setUp(() {
      tagDataSourceSpy = FirebaseTagDataSourceSpy(delete: true);
      sut = TagRepository(tagDataSource: tagDataSourceSpy);
    });

    test("Deve chamar delete com valores corretos", () async {
      await sut.delete(tagId);
      verify(() => tagDataSourceSpy.delete(tagId));
    });

    test("Deve throw StandardError", () {
      tagDataSourceSpy.mockDeleteError(error: StandardError());

      final Future future = sut.delete(tagId);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      tagDataSourceSpy.mockDeleteError(error: UnexpectedError());

      final Future future = sut.delete(tagId);
      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      tagDataSourceSpy.mockDeleteError();

      final Future future = sut.delete(tagId);
      expect(future, throwsA(isA()));
    });
  });
}
