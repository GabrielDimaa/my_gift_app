import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/wishlist_entity.dart';
import './tag_viewmodel.dart';
import './wish_viewmodel.dart';

class WishlistViewModel {
  final RxnString _id = RxnString();
  final RxnString _description = RxnString();
  final RxList<WishViewModel> _wishes = RxList<WishViewModel>();
  final Rxn<TagViewModel> _tag = Rxn<TagViewModel>();

  //Propriedade apenas para controle de tela.
  bool? deleted = false;

  String? get id => _id.value;
  String? get description => _description.value;
  List<WishViewModel> get wishes => _wishes;
  TagViewModel? get tag => _tag.value;

  void setDescription(String? value) => _description.value = value;
  void setWishes(List<WishViewModel> value) => _wishes.value = value;
  void setTag(TagViewModel? value) => _tag.value = value;

  WishlistViewModel({String? id, String? description, List<WishViewModel>? wishes, TagViewModel? tag}) {
    _id.value = id;
    _description.value = description;
    _wishes.value = wishes ?? [];
    _tag.value = tag;
  }

  WishlistEntity toEntity(UserEntity user) {
    return WishlistEntity(
      id: id,
      user: user,
      description: description!,
      wishes: wishes.map((e) => e.toEntity(user)).toList(),
      tag: tag!.toEntity(user),
    );
  }

  WishlistViewModel clone() {
    return WishlistViewModel(
      id: id,
      description: description,
      wishes: wishes.map((e) => e.clone()).toList(),
      tag: tag?.clone(),
    );
  }

  factory WishlistViewModel.fromEntity(WishlistEntity entity) {
    return WishlistViewModel(
      id: entity.id,
      description: entity.description,
      wishes: entity.wishes.map((e) => WishViewModel.fromEntity(e)).toList(),
      tag: TagViewModel.fromEntity(entity.tag),
    );
  }
}
