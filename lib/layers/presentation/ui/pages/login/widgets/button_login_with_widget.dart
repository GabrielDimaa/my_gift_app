import 'package:flutter/material.dart';

import '../../../components/sized_box_default.dart';

class ButtonLoginWithWidget extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const ButtonLoginWithWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onPressed,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF464646), width: 2),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBoxDefault.horizontal(),
            Text(text, style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
