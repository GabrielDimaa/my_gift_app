import '../../../../i18n/resources.dart';

enum PriceRange {
  pr1_100,
  pr100_200,
  pr200_300,
  pr300_400,
  pr400_500,
  pr500,
}

extension PriceRangeExtension on PriceRange {
  String get description {
    switch (this) {
      case PriceRange.pr1_100: return "1 - 100";
      case PriceRange.pr100_200: return "100 - 200";
      case PriceRange.pr200_300: return "200 - 300";
      case PriceRange.pr300_400: return "300 - 400";
      case PriceRange.pr400_500: return "400 - 500";
      case PriceRange.pr500: return "500...";
      default: return "1 - 100";
    }
  }

  double get min {
    switch (this) {
      case PriceRange.pr1_100: return 0;
      case PriceRange.pr100_200: return 100;
      case PriceRange.pr200_300: return 200;
      case PriceRange.pr300_400: return 300;
      case PriceRange.pr400_500: return 400;
      case PriceRange.pr500: return 500;
      default: return 0;
    }
  }

  double get max {
    switch (this) {
      case PriceRange.pr1_100: return 100;
      case PriceRange.pr100_200: return 200;
      case PriceRange.pr200_300: return 300;
      case PriceRange.pr300_400: return 400;
      case PriceRange.pr400_500: return 500;
      case PriceRange.pr500: return 1000;
      default: return 0;
    }
  }

  static PriceRange getPriceRange(double min, double max) {
    if (min > max) throw Exception(R.string.priceMinMaxError);

    if (min >= PriceRange.pr1_100.min && max <= PriceRange.pr1_100.max) return PriceRange.pr1_100;
    if (min >= PriceRange.pr100_200.min && max <= PriceRange.pr100_200.max) return PriceRange.pr100_200;
    if (min >= PriceRange.pr200_300.min && max <= PriceRange.pr200_300.max) return PriceRange.pr200_300;
    if (min >= PriceRange.pr300_400.min && max <= PriceRange.pr300_400.max) return PriceRange.pr300_400;
    if (min >= PriceRange.pr400_500.min && max <= PriceRange.pr400_500.max) return PriceRange.pr400_500;
    if (min >= PriceRange.pr500.min) return PriceRange.pr500;

    return PriceRange.pr100_200;
  }
}
