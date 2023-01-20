import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.citynameController,
              decoration: const InputDecoration(
                hintText: "Enter city name",
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (controller.citynameController.text.isNotEmpty) {
                  controller.getWeatherDataByLatLong();
                } else {
                  Get.rawSnackbar(
                    title: "City name is required",
                    message: "Please enter a city name",
                  );
                }
              },
              icon: Obx(
                () {
                  if (controller.wedharstates == States.loding) {
                    return const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  } else if (controller.wedharstates == States.succses) {
                    return const Icon(Icons.done);
                  } else if (controller.wedharstates == States.error) {
                    return const Icon(Icons.cancel_outlined);
                  } else {
                    return const Icon(Icons.search);
                  }
                },
              ),
              label: const Text("search"),
            ),
          ],
        ),
      ),
    );
  }
}
