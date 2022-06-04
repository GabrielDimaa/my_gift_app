import 'package:get/get.dart';

import '../../domain/entities/wishlist_entity.dart';
import './tag_viewmodel.dart';

class WishlistViewModel {
  RxnString id = RxnString();
  RxnString description = RxnString();
  Rxn<TagViewModel> tag = Rxn<TagViewModel>();

  void setDescription(String? value) => description.value = value;

  void setTag(TagViewModel? value) => tag.value = value;

  WishlistViewModel({String? id, String? description, TagViewModel? tag}) {
    this.id.value = id;
    this.description.value = description;
    this.tag.value = tag;
  }

  factory WishlistViewModel.fromEntity(WishlistEntity entity) {
    return WishlistViewModel(
      id: entity.id,
      description: entity.description,
      tag: TagViewModel.fromEntity(entity.tag),
    );
  }
}
