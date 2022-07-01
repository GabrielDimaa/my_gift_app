import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';

class BottomSheetDefault extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool enablePop;
  final EdgeInsets? contentPadding;

  const BottomSheetDefault({
    Key? key,
    this.title,
    required this.child,
    this.enablePop = true,
    this.contentPadding,
  }) : super(key: key);

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    VoidCallback? onClosing,
    bool? isScrollControlled,
    bool? isDismissible,
    bool? enableDrag,
    bool? enablePop,
    EdgeInsets? contentPadding,
  }) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled ?? false,
      isDismissible: isDismissible ?? true,
      enableDrag: enableDrag ?? true,
      builder: (_) => BottomSheetDefault(
        title: title,
        enablePop: enablePop ?? true,
        contentPadding: contentPadding,
        child: child,
      ),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: title != null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 24, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title ?? "",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: contentPadding ?? const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
