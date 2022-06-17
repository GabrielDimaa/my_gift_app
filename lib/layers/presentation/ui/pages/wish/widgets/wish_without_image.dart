import 'package:flutter/material.dart';

class WishWithoutImage extends StatelessWidget {
  final double? size;
  final double? iconSize;
  const WishWithoutImage({Key? key, this.size, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: const Color(0xFF464646), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      height: size ?? 70,
      width: size ?? 70,
      child: Icon(Icons.photo, size: iconSize ?? 36),
    );
  }
}
