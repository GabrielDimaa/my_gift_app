import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool visible;
  final double iconSize;

  const ButtonAction({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.visible = true,
    this.iconSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: ElevatedButton.icon(
        label: Text(label),
        icon: Icon(icon, size: iconSize),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        ),
      ),
    );
  }
}
