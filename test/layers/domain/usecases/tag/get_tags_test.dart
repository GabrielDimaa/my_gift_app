import 'package:desejando_app/layers/domain/usecases/tag/get_tags.dart';
import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/mocks/tag_repository_spy.dart';

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

  test("Deve throw UnexpectedDomainError", () {
    tagRepositorySpy.mockGetAllError();

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}