import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../app_theme.dart';

class ImageLoaderDefault extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final double radius;

  const ImageLoaderDefault({
    Key? key,
    required this.image,
    required this.width,
    required this.height,
    this.radius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: (Uri.tryParse(image)?.isAbsolute ?? false)
          ? Image.network(
              image,
              height: height,
              width: width,
              frameBuilder: frameBuilder,
            )
          : Image.file(
              File(image),
              height: height,
              width: width,
              frameBuilder: frameBuilder,
            ),
    );
  }

  Widget frameBuilder(BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) return child;

    if (frame == null) {
      return Shimmer.fromColors(
        baseColor: AppTheme.theme.value == ThemeMode.dark ? const Color(0xFF3a3a3a) : Colors.grey[400]!,
        highlightColor: AppTheme.theme.value == ThemeMode.dark ? const Color(0xFF606060) : Colors.grey[200]!,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
      );
    }

    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
      child: child,
    );
  }
}
