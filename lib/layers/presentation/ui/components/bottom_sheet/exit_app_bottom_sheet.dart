import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import 'confirm_bottom_sheet.dart';

abstract class ExitAppBottomSheet {
  static Future<bool> show(BuildContext context) async {
    return await ConfirmBottomSheet.show(
      context: context,
      title: R.string.exit,
      message: R.string.exitMessage,
    );
  }
}
