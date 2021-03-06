import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/tag_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/tag/get_tags.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/tag_repository_spy.dart';

void main() {
  late GetTags sut;
  late TagRepositorySpy tagRepositorySpy;

  final List<TagEntity> tagsResult = EntityFactory.tags();
  final String userId = faker.guid.guid();

  setUp(() {
    tagRepositorySpy = TagRepositorySpy(datas: tagsResult, get: true);
    sut = GetTags(tagRepository: tagRepositorySpy);
  });

  test("Deve chamar getAll com valores corretos", () async {
    await sut.get(userId);
    verify(() => tagRepositorySpy.getAll(userId));
  });

  test("Deve chamar getAll e retornar os valores com sucesso", () async {
    final List<TagEntity> tags = await sut.get(userId);
    expect(tags.equals(tagsResult), true);
  });

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    tagRepositorySpy.mockGetAllError(error: UnexpectedError());

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    tagRepositorySpy.mockGetAllError(error: StandardError());

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    tagRepositorySpy.mockGetAllError(error: Exception());

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<Exception>()));
  });
}