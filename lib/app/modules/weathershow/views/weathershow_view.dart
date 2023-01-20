import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/weathershow_controller.dart';

class WeathershowView extends GetView<WeathershowController> {
  const WeathershowView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeathershowView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${controller.homeController.weather?.main?.temp}",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              "${controller.homeController.weather?.name}",
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
