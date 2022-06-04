import 'package:get/get.dart';

import '../../domain/entities/tag_entity.dart';

class TagViewModel {
  RxnString id = RxnString();
  RxnString name = RxnString();
  RxnInt color = RxnInt();

  void setName(String? value) => name.value = value;

  void setColor(int? value) => color.value = value;

  TagViewModel({String? id, String? name, int? color}) {
    this.id.value = id;
    this.name.value = name;
    this.color.value = color;
  }

  factory TagViewModel.fromEntity(TagEntity entity) {
    return TagViewModel(
      id: entity.id,
      name: entity.name,
      color: int.tryParse("0xFF${entity.color}") ?? 0xFFFFFF,
    );
  }
}
