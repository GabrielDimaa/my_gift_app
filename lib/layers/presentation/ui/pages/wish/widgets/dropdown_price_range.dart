import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../helpers/enums/price_range.dart';
import '../../../../presenters/wish/abstracts/wish_register_presenter.dart';

class DropdownPriceRange extends StatelessWidget {
  final WishRegisterPresenter presenter;

  const DropdownPriceRange({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: DropdownButton(
          value: presenter.priceRangeSelected,
          onChanged: presenter.setPriceRange,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(18),
          style: Theme.of(context).textTheme.button?.copyWith(fontSize: 14, color: const Color(0xFFC1C1C1)),
          isDense: true,
          icon: Icon(Icons.arrow_drop_down_outlined, color: Theme.of(context).colorScheme.secondary),
          items: [
            DropdownMenuItem<PriceRange>(child: Text(PriceRange.pr1_100.description), value: PriceRange.pr1_100),
            DropdownMenuItem<PriceRange>(child: Text(PriceRange.pr100_200.description), value: PriceRange.pr100_200),
            DropdownMenuItem<PriceRange>(child: Text(PriceRange.pr200_300.description), value: PriceRange.pr200_300),
            DropdownMenuItem<PriceRange>(child: Text(PriceRange.pr300_400.description), value: PriceRange.pr300_400),
            DropdownMenuItem<PriceRange>(child: Text(PriceRange.pr400_500.description), value: PriceRange.pr400_500),
            DropdownMenuItem<PriceRange>(child: Text(PriceRange.pr500.description), value: PriceRange.pr500),
          ],
        ),
      ),
    );
  }
}
