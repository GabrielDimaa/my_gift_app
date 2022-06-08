import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/wishlist/implements/getx_wishlists_list_presenter.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/button/fab_default.dart';
import '../../components/circular_loading.dart';
import '../../components/not_found.dart';
import '../../components/padding/padding_default.dart';
import 'components/list_wishlists.dart';

class WishlistsFetchPage extends StatefulWidget {
  const WishlistsFetchPage({Key? key}) : super(key: key);

  @override
  _WishlistsFetchPageState createState() => _WishlistsFetchPageState();
}

class _WishlistsFetchPageState extends State<WishlistsFetchPage> {
  final GetxWishlistsFetchPresenter presenter = Get.find<GetxWishlistsFetchPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.wishlists),
      floatingActionButton: FABDefault(
        icon: Icons.add,
        onPressed: () async => await _navigateWishlist(null),
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
                      child: Builder(builder: (_) {
                        if (presenter.viewModel.wishlists.isEmpty) {
                          return Stack(
                            children: [
                              NotFound(message: R.string.notFoundWishlists),
                              ListView(),
                            ],
                          );
                        } else {
                          return ListWishlists(
                            list: presenter.viewModel.wishlists,
                            onTapListTile: _navigateWishlist,
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

  Future<void> _navigateWishlist(WishlistViewModel? viewModel) async {
    await Navigator.of(context).pushNamed("wishlist_register", arguments: viewModel);
  }
}
