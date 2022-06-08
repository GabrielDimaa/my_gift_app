import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../../i18n/resources.dart';
import '../../../components/sized_box_default.dart';

class ChipAddTag extends StatelessWidget {
  final VoidCallback onTap;

  const ChipAddTag({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: DottedBorder(
          color: Theme.of(context).colorScheme.onBackground,
          strokeWidth: 2,
          dashPattern: const [3, 3],
          borderType: BorderType.RRect,
          radius: const Radius.circular(100),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          child: Row(
            children: [
              const Icon(Icons.add, size: 20),
              const SizedBoxDefault.horizontal(),
              Text(R.string.addTag, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
