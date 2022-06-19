import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/user_entity.dart';

class PhotoProfileAction extends StatelessWidget {
  const PhotoProfileAction({Key? key}) : super(key: key);

  UserEntity get _user => UserGlobal().getUser()!;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _user.photo != null,
      replacement: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          _user.name.characters.first,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: _user.photo ?? "",
        imageBuilder: (_, image) => CircleAvatar(backgroundImage: image),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
