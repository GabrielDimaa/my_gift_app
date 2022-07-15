import 'package:flutter/widgets.dart';

import '../../../../../i18n/resources.dart';
import 'confirm_bottom_sheet.dart';

abstract class DiscardChangesBottomSheet {
  static Future<bool> show(BuildContext context) async {
    return await ConfirmBottomSheet.show(
      context: context,
      title: R.string.discard,
      message: R.string.discardChangesMessage,
      confirmButton: R.string.discard,
    );
  }
}
