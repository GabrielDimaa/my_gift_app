import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: Text(R.string.save),
      icon: const Icon(Icons.check),
      onPressed: onPressed,
    );
  }
}
