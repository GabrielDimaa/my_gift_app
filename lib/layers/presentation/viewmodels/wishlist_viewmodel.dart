import 'package:get/get.dart';

import '../../domain/entities/wishlist_entity.dart';
import './tag_viewmodel.dart';

class WishlistViewModel {
  final RxnString _id = RxnString();
  final RxnString _description = RxnString();
  final Rxn<TagViewModel> _tag = Rxn<TagViewModel>();

  String? get id => _id.value;
  String? get description => _description.value;
  TagViewModel? get tag => _tag.value;

  void setDescription(String? value) => _description.value = value;
  void setTag(TagViewModel? value) => _tag.value = value;

  WishlistViewModel({String? id, String? description, TagViewModel? tag}) {
    _id.value = id;
    _description.value = description;
    _tag.value = tag;
  }

  factory WishlistViewModel.fromEntity(WishlistEntity entity) {
    return WishlistViewModel(
      id: entity.id,
      description: entity.description,
      tag: TagViewModel.fromEntity(entity.tag),
    );
  }
}
