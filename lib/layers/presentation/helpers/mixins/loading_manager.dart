import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../interfaces/i_loading.dart';

mixin LoadingManager on GetxController implements ILoading {
  final RxBool _loading = false.obs;

  @override
  bool get loading => _loading.value;

  @override
  void setLoading(bool value) => _loading.value = value;
}