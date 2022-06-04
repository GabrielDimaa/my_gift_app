import 'package:flutter/material.dart';

class FABDefault extends FloatingActionButton {
  final IconData icon;

  FABDefault({
    Key? key,
    required this.icon,
    required VoidCallback? onPressed,
    String? tooltip,
  }) : super(
          key: key,
          child: Icon(icon, size: 30),
          onPressed: onPressed,
          tooltip: tooltip,
        );
}
