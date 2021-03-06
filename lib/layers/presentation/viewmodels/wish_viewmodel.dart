import 'package:get/get.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/wish_entity.dart';

class WishViewModel {
  final RxnString _id = RxnString();
  final RxnString _userId = RxnString();
  final RxnString _wishlistId = RxnString();
  final RxnString _description = RxnString();
  final RxnString _image = RxnString();
  final RxnString _link = RxnString();
  final RxnString _note = RxnString();
  final RxnDouble _priceRangeInitial = RxnDouble();
  final RxnDouble _priceRangeFinal = RxnDouble();
  final Rxn<DateTime> _createdAt = Rxn<DateTime>();

  //Propriedade apenas para controle de tela.
  bool? deleted = false;

  String? get id => _id.value;
  String? get userId => _userId.value;
  String? get wishlistId => _wishlistId.value;
  String? get description => _description.value;
  String? get image => _image.value;
  String? get link => _link.value;
  String? get note => _note.value;
  double? get priceRangeInitial => _priceRangeInitial.value;
  double? get priceRangeFinal => _priceRangeFinal.value;
  DateTime? get createdAt => _createdAt.value;

  void setWishlistId(String? value) => _wishlistId.value = value;
  void setDescription(String? value) => _description.value = value;
  void setImage(String? value) => _image.value = value;
  void setLink(String? value) => _link.value = value;
  void setNote(String? value) => _note.value = value;
  void setPriceRangeInitial(double? value) => _priceRangeInitial.value = value;
  void setPriceRangeFinal(double? value) => _priceRangeFinal.value = value;
  void setCreatedAt(DateTime? value) => _createdAt.value = value;

  WishViewModel({
    String? id,
    String? userId,
    String? wishlistId,
    String? description,
    String? image,
    String? link,
    String? note,
    double? priceRangeInitial,
    double? priceRangeFinal,
    DateTime? createdAt,
  }) {
    _id.value = id;
    _userId.value = userId;
    _wishlistId.value = wishlistId;
    _description.value = description;
    _image.value = image;
    _link.value = link;
    _note.value = note;
    _priceRangeInitial.value = priceRangeInitial;
    _priceRangeFinal.value = priceRangeFinal;
    _createdAt.value = createdAt;
  }

  WishEntity toEntity(UserEntity user) {
    return WishEntity(
      id: id,
      user: user,
      wishlistId: wishlistId,
      description: description!,
      image: image,
      link: link,
      note: note,
      priceRangeInitial: priceRangeInitial!,
      priceRangeFinal: priceRangeFinal!,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  WishViewModel clone() {
    return WishViewModel(
      id: id,
      userId: userId,
      wishlistId: wishlistId,
      description: description,
      image: image,
      link: link,
      note: note,
      priceRangeInitial: priceRangeInitial,
      priceRangeFinal: priceRangeFinal,
      createdAt: createdAt,
    );
  }

  void updateViewModel(WishViewModel viewModel) {
    setDescription(viewModel.description);
    setImage(viewModel.image);
    setLink(viewModel.link);
    setNote(viewModel.note);
    setPriceRangeInitial(viewModel.priceRangeInitial);
    setPriceRangeFinal(viewModel.priceRangeFinal);
    setCreatedAt(viewModel.createdAt);
  }

  factory WishViewModel.fromEntity(WishEntity entity) {
    return WishViewModel(
      id: entity.id,
      userId: entity.user.id,
      wishlistId: entity.wishlistId,
      description: entity.description,
      image: entity.image,
      link: entity.link,
      note: entity.note,
      priceRangeInitial: entity.priceRangeInitial,
      priceRangeFinal: entity.priceRangeFinal,
      createdAt: entity.createdAt,
    );
  }
}
