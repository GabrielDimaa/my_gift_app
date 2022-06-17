import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool visible;

  const ButtonAction({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: ElevatedButton.icon(
        label: Text(label),
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: Theme.of(context).textTheme.button?.copyWith(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        ),
      ),
    );
  }
}
