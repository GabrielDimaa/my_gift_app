import 'package:flutter/material.dart';

class ChipTag extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final void Function(bool)? onSelected;
  final Color backgroundColorDisable;
  final Color onBackgroundColorDisable;

  const ChipTag({
    Key? key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onSelected,
    required this.backgroundColorDisable,
    required this.onBackgroundColorDisable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? color : onBackgroundColorDisable,
          fontSize: 16,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: color.withOpacity(0.1),
      side: BorderSide(color: selected ? color : const Color(0xFF464646)),
      backgroundColor: backgroundColorDisable,
      labelPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
    );
  }
}
