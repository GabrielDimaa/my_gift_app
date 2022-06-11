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
}
