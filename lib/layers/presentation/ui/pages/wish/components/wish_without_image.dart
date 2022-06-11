import 'package:flutter/material.dart';

class WishWithoutImage extends StatelessWidget {
  const WishWithoutImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: const Color(0xFF464646), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 70,
      width: 70,
      child: const Icon(Icons.photo, size: 36),
    );
  }
}
