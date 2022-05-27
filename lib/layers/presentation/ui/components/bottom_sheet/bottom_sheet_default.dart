import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';

class BottomSheetDefault extends StatelessWidget {
  final String? title;
  final Widget child;

  const BottomSheetDefault({Key? key, this.title, required this.child}) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    required Widget child,
    String? title,
    VoidCallback? onClosing,
  }) async {
    return await showModalBottomSheet(
      context: context,
      builder: (_) => BottomSheetDefault(title: title, child: child),
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
              onPressed: () => Navigator.pop(context),
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
                    padding: const EdgeInsets.only(top: 10, bottom: 24),
                    child: Align(
                      alignment: Alignment.center,
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
