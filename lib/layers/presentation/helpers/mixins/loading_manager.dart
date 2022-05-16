import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

mixin LoadingManager on GetxController {
  final RxBool _loading = false.obs;

  bool get loading => _loading.value;
  void setLoading(bool value) => _loading.value = value;
}