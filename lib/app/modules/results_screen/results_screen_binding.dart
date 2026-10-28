import 'package:get/get.dart';

import 'results_screen_controller.dart';

class ResultsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultsScreenController>(
      () => ResultsScreenController(),
    );
  }
}
