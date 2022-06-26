import 'package:flutter/material.dart';

import '../../../../../../i18n/resources.dart';
import '../../../../viewmodels/user_viewmodel.dart';
import '../../../components/images/image_loader_default.dart';

class PersonListTile extends StatelessWidget {
  final UserViewModel person;
  final bool isAddFriend;
  final VoidCallback onPressedTrailing;
  final VoidCallback onTapTile;

  const PersonListTile({
    Key? key,
    required this.person,
    required this.isAddFriend,
    required this.onPressedTrailing,
    required this.onTapTile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      onTap: onTapTile,
      leading: _photoProfile(context: context),
      title: Text(person.shortName),
      trailing: IconButton(
        icon: Icon(
          isAddFriend ? Icons.person_add_outlined : Icons.person_remove_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        tooltip: isAddFriend ? R.string.addFriend : R.string.undoFriend,
        onPressed: onPressedTrailing,
      ),
    );
  }

  Widget _photoProfile({required BuildContext context}) {
    if (person.photo == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Text(
          person.name.characters.first,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    } else {
      return ImageLoaderDefault(
        image: person.photo!,
        height: 50,
        width: 50,
        radius: 500,
      );
    }
  }
}
