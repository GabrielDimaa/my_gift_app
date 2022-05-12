import 'package:flutter/widgets.dart';

class SizedBoxDefault extends SizedBox {
  static const double space = 12;

  const SizedBoxDefault([double qtd = 1])
      : assert(qtd > 0),
        super(height: space * qtd);

  const SizedBoxDefault.horizontal([double qtd = 1])
      : assert(qtd > 0),
        super(width: space * qtd);
}