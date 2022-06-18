import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/wishlist/abstracts/wishlists_fetch_presenter.dart';
import '../../../presenters/wishlist/implements/getx_wishlists_fetch_presenter.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/button/fab_default.dart';
import '../../components/circular_loading.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';

class WishlistsFetchPage extends StatefulWidget {
  const WishlistsFetchPage({Key? key}) : super(key: key);

  @override
  State<WishlistsFetchPage> createState() => _WishlistsFetchPageState();
}

class _WishlistsFetchPageState extends State<WishlistsFetchPage> {
  final WishlistsFetchPresenter presenter = Get.find<GetxWishlistsFetchPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.wishlists),
      floatingActionButton: FABDefault(
        icon: Icons.add,
        onPressed: () async => await _navigateWishlistRegister(),
        tooltip: R.string.createWishlist,
      ),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Obx(() {
                  if (presenter.loading) {
                    return const CircularLoading();
                  } else {
                    return RefreshIndicator(
                      onRefresh: presenter.fetchWishlists,
                      child: Obx(() {
                        if (presenter.viewModel.wishlists.isEmpty) {
                          return Stack(
                            children: [
                              NotFound(message: R.string.notFoundWishlists),
                              ListView(),
                            ],
                          );
                        } else {
                          return ListView.builder(
                            itemCount: presenter.viewModel.wishlists.length,
                            itemBuilder: (_, index) {
                              final WishlistViewModel wishlist = presenter.viewModel.wishlists[index];
                              return ListTile(
                                onTap: () async => await _navigateWishlistDetails(wishlist, index),
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
                      }),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateWishlistRegister() async {
    final WishlistViewModel? wishlist = await Navigator.pushNamed(context, "wishlist_register") as WishlistViewModel?;
    if (wishlist != null) presenter.viewModel.wishlists.insert(0, wishlist);
  }

  Future<void> _navigateWishlistDetails(WishlistViewModel? viewModel, int index) async {
    final WishlistViewModel? wishlist = await Navigator.pushNamed(context, "wishlist_details", arguments: viewModel?.clone()) as WishlistViewModel?;
    if (wishlist != null) presenter.viewModel.wishlists[index] = wishlist;
  }
}
