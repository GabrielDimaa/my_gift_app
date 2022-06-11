import 'package:intl/intl.dart';

import '../i18n/resources.dart';

extension DoubleExtension on double {
  String get money => NumberFormat.currency(locale: R.string.locale, decimalDigits: 2, symbol: R.string.symbol).format(this).trim();

  String get moneyWithoutSymbol => NumberFormat.currency(locale: R.string.locale, decimalDigits: 2, symbol: "").format(this).trim();
}