import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../sized_box_default.dart';

class AppBarDefault extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final VoidCallback? onBackPressed;
  final bool visibleBackButton;

  const AppBarDefault({
    Key? key,
    required this.title,
    this.actions = const [],
    this.onBackPressed,
    this.visibleBackButton = true,
  }) : super(key: key);

  static double get toolbarHeight => 110;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBoxDefault(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: visibleBackButton && Navigator.canPop(context),
                replacement: const SizedBox(height: 48),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 38,
                    splashRadius: 32,
                    icon: const Icon(Icons.keyboard_backspace),
                    onPressed: onBackPressed ?? () => Navigator.pop(context),
                    tooltip: R.string.back,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: actions,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(title, style: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
      actions: const [SizedBox.shrink()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
