import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';

class BottomSheetDefault extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool enablePop;

  const BottomSheetDefault({Key? key, this.title, required this.child, this.enablePop = true}) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required Widget child,
    String? title,
    VoidCallback? onClosing,
    bool? isScrollControlled,
    bool? isDismissible,
    bool? enableDrag,
    bool? enablePop,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled ?? false,
      isDismissible: isDismissible ?? false,
      enableDrag: enableDrag ?? true,
      builder: (_) => BottomSheetDefault(title: title, child: child, enablePop: enablePop ?? true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      enableDrag: false,
      builder: (_) => Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.close),
              tooltip: R.string.close,
              onPressed: () => enablePop ? Navigator.pop(context) : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: title != null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title ?? "",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
