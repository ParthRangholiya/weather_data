import 'package:get/get.dart';

import '../controllers/weathershow_controller.dart';

class WeathershowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeathershowController>(
      () => WeathershowController(),
    );
  }
}
