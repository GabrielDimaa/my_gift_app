import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/wishlist/get_wishlists_by_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/mocks/wishlist_repository_spy.dart';

void main() {
  late GetWishlistByTag sut;
  late WishlistRepositorySpy wishlistRepositorySpy;

  final TagEntity tag = EntityFactory.tag();
  final List<WishlistEntity> wishlistResult = EntityFactory.wishlists();

  setUp(() {
    wishlistRepositorySpy = WishlistRepositorySpy(datas: wishlistResult);
    sut = GetWishlistByTag(wishlistRepository: wishlistRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(tag));

  test("Deve chamar getByTag com valores corretos", () async {
    await sut.get(tag);
    verify(() => wishlistRepositorySpy.getByTag(tag));
  });

  test("Deve chamar getByTag e retornar dados com sucesso", () async {
    final List<WishlistEntity> wishlists = await sut.get(tag);
    expect(wishlists.equals(wishlistResult), true);
  });

  test("Deve throw UnexpectedDomainError", () {
    wishlistRepositorySpy.mockGetByTagError();

    final Future future = sut.get(tag);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}