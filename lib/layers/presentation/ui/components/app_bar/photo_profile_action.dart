import 'package:flutter/material.dart';

import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/user_entity.dart';
import '../photo_profile.dart';

class PhotoProfileAction extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PhotoProfileAction({Key? key, required this.scaffoldKey}) : super(key: key);

  UserEntity get _user => UserGlobal().getUser()!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => scaffoldKey.currentState?.openEndDrawer(),
      child: PhotoProfile(user: _user),
    );
  }
}
