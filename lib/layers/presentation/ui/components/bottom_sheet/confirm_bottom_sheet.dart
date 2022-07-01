import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../sized_box_default.dart';
import 'bottom_sheet_default.dart';

class ConfirmBottomSheet extends StatelessWidget {
  final String message;

  const ConfirmBottomSheet({
    Key? key,
    required this.message,
  }) : super(key: key);

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return await BottomSheetDefault.show<bool>(
          context: context,
          title: title,
          child: ConfirmBottomSheet(message: message),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(message),
        const SizedBoxDefault(3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                R.string.cancel,
                style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                R.string.confirm,
                style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
