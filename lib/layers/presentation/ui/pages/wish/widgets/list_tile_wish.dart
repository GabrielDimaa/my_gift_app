import 'package:flutter/material.dart';

import '../../../../../../../extensions/double_extension.dart';
import '../../../../viewmodels/wish_viewmodel.dart';
import '../../../components/dismissible_default.dart';
import '../../../components/images/image_loader_default.dart';
import '../../../components/sized_box_default.dart';
import 'wish_without_image.dart';

class ListTileWish extends StatelessWidget {
  final WishViewModel viewModel;
  final VoidCallback? onTap;
  final void Function(DismissDirection)? onDismissed;
  final Future<bool> Function(DismissDirection)? confirmDismiss;
  final EdgeInsets? contentPadding;

  const ListTileWish({
    Key? key,
    required this.viewModel,
    required this.onTap,
    this.onDismissed,
    this.confirmDismiss,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissibleDefault<WishViewModel>(
      valueKey: viewModel,
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      child: ListTile(
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        onTap: onTap,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageWish(viewModel.image),
            const SizedBoxDefault.horizontal(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(viewModel.description!),
                  Text(
                    "${viewModel.priceRangeInitial!.money} - ${viewModel.priceRangeFinal!.money}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBoxDefault.horizontal(),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _imageWish(String? image) {
    if (image == null) {
      return const WishWithoutImage();
    } else {
      return ImageLoaderDefault(
        image: image,
        height: 70,
        width: 70,
        radius: 12,
      );
    }
  }
}
