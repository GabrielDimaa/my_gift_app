import '../../../i18n/resources.dart';
import '../entities/tag_entity.dart';
import '../entities/user_entity.dart';

enum TagInternal {
  normal
}

extension TagInternalExtension on TagInternal {
  int get value {
    switch (this) {
      case TagInternal.normal: return 1;
    }
  }

  String get description {
    switch (this) {
      case TagInternal.normal: return R.string.tagNormal;
    }
  }

  String get color {
    switch (this) {
      case TagInternal.normal: return "F8C630";
    }
  }

  TagEntity toEntity(UserEntity user) => TagEntity(id: value.toString(), user: user, name: description, color: color);
}