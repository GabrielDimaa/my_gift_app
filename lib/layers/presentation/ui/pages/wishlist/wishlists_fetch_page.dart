import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../routes/routes.dart';
import '../../../presenters/wishlist/abstracts/wishlists_fetch_presenter.dart';
import '../../../presenters/wishlist/implements/getx_wishlists_fetch_presenter.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/button/fab_default.dart';
import '../../components/circular_loading.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';
import 'components/wishlist_list_tile.dart';

class WishlistsFetchPage extends StatefulWidget {
  const WishlistsFetchPage({Key? key}) : super(key: key);

  @override
  State<WishlistsFetchPage> createState() => _WishlistsFetchPageState();
}

class _WishlistsFetchPageState extends State<WishlistsFetchPage> {
  final WishlistsFetchPresenter presenter = Get.find<GetxWishlistsFetchPresenter>();

  @override
  void initState() {
    presenter.initialize().catchError((e) => ErrorDialog.show(context: context, content: e.toString()));
    super.initState();
  }

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
                          return ListView.separated(
                            itemCount: presenter.viewModel.wishlists.length,
                            separatorBuilder: (_, __) => const Divider(thickness: 1, height: 1),
                            itemBuilder: (_, index) {
                              final WishlistViewModel wishlist = presenter.viewModel.wishlists[index];
                              return WishlistListTile(
                                viewModel: wishlist,
                                onTap: () async => await _navigateWishlistDetails(wishlist, index),
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
    final WishlistViewModel? wishlist = await Navigator.pushNamed(context, wishlistRegisterRoute) as WishlistViewModel?;
    if (wishlist != null) presenter.viewModel.wishlists.insert(0, wishlist);
  }

  Future<void> _navigateWishlistDetails(WishlistViewModel? viewModel, int index) async {
    final WishlistViewModel? wishlist = await Navigator.pushNamed(context, wishlistDetailsRoute, arguments: viewModel?.clone()) as WishlistViewModel?;
    if (wishlist != null) {
      if (wishlist.deleted ?? false) {
        presenter.viewModel.wishlists.removeAt(index);
      } else {
        presenter.viewModel.wishlists[index] = wishlist;
      }
    }
  }
}
