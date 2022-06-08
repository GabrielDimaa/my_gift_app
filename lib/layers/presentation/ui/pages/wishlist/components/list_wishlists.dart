import 'package:flutter/material.dart';

import '../../../../viewmodels/wishlist_viewmodel.dart';

class ListWishlists extends StatelessWidget {
  final List<WishlistViewModel> list;
  final Future<void> Function(WishlistViewModel?) onTapListTile;

  const ListWishlists({Key? key, required this.list, required this.onTapListTile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, index) {
        final WishlistViewModel wishlist = list[index];
        return ListTile(
          onTap: () async => await onTapListTile.call(wishlist),
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          title: Text(wishlist.description!),
          subtitle: Text(
            wishlist.tag?.name ?? "",
            style: TextStyle(
              color: Color(wishlist.tag?.color ?? 0),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 32,
          ),
          shape: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF303134)),
            borderRadius: BorderRadius.zero,
          ),
        );
      },
    );
  }
}
