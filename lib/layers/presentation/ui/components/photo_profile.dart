import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';

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
      child: CachedNetworkImage(
        imageUrl: user.photo ?? "",
        imageBuilder: (_, image) => CircleAvatar(backgroundImage: image),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
