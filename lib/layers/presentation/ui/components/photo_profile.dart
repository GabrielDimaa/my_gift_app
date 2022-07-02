import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';
import 'images/image_loader_default.dart';

class PhotoProfile extends StatelessWidget {
  final UserEntity user;

  const PhotoProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: user.photo != null,
      replacement: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          user.name.characters.first,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      child: CircleAvatar(
        child: ImageLoaderDefault(
          image: user.photo ?? "",
          width: 100,
          height: 100,
          radius: 100,
        ),
      ),
    );
  }
}
