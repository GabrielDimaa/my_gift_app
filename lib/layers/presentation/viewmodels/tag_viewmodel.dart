import 'package:get/get.dart';

import '../../../extensions/string_extension.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/entities/user_entity.dart';

class TagViewModel {
  final RxnString _id = RxnString();
  final RxnString _name = RxnString();
  final RxnInt _color = RxnInt();

  String? get id => _id.value;
  String? get name => _name.value;
  int? get color => _color.value;

  void setName(String? value) => _name.value = value;
  void setColor(int? value) => _color.value = value;

  TagViewModel({String? id, String? name, int? color}) {
    _id.value = id;
    _name.value = name;
    _color.value = color;
  }

  TagEntity toEntity(UserEntity user) {
    return TagEntity(
      id: id,
      user: user,
      name: name!,
      color: color!.toRadixString(16),
    );
  }

  factory TagViewModel.fromEntity(TagEntity entity) {
    return TagViewModel(
      id: entity.id,
      name: entity.name,
      color: entity.color.toColor(),
    );
  }
}
