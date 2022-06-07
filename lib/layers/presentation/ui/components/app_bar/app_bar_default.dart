import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../sized_box_default.dart';

class AppBarDefault extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const AppBarDefault({Key? key, required this.title, this.actions = const []}) : super(key: key);

  double get toolbarHeight => 110;

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
          Visibility(
            visible: Navigator.canPop(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 38,
                splashRadius: 28,
                icon: const Icon(Icons.keyboard_backspace),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: R.string.back,
              ),
            ),
            replacement: const SizedBox(height: 48),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(title, style: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBoxDefault(),
            Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: actions),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
