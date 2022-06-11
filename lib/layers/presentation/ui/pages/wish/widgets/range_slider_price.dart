import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../../extensions/double_extension.dart';
import '../../../../helpers/enums/price_range.dart';
import '../../../../presenters/wish/abstracts/wish_register_presenter.dart';

class RangeSliderPrice extends StatelessWidget {
  final WishRegisterPresenter presenter;

  const RangeSliderPrice({Key? key, required this.presenter}) : super(key: key);

  double get startRangeSliderDefault => presenter.priceRangeSelected.min + 20;

  double get endRangeSliderDefault => presenter.priceRangeSelected.max - 20;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final double start = presenter.viewModel.priceRangeInitial ?? startRangeSliderDefault;
        final double end = presenter.viewModel.priceRangeFinal ?? endRangeSliderDefault;
        return RangeSlider(
          min: presenter.priceRangeSelected.min,
          max: presenter.priceRangeSelected.max,
          values: RangeValues(start, end),
          divisions: (10),
          labels: RangeLabels(start.moneyWithoutSymbol, end.moneyWithoutSymbol),
          onChanged: (RangeValues values) {
            presenter.viewModel.setPriceRangeInitial(values.start);
            presenter.viewModel.setPriceRangeFinal(values.end);
          },
        );
      },
    );
  }
}
