import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather1/app/data/keys.dart';
import 'package:weather1/app/data/models/weather_data.dart';
import 'package:weather1/app/data/urls.dart';
import '../../../routes/app_pages.dart';

enum States { initial, succses, loding, error }

class HomeController extends GetxController {
  TextEditingController citynameController = TextEditingController();

  final _data = Rx<Weather?>(null);
  Weather? get weather => _data.value;
  set data(Weather? value) => _data.value = value;

  final _wedharstates = Rx<States>(States.initial);
  States get wedharstates => _wedharstates.value;
  set wedharstates(States value) => _wedharstates.value = value;

  Future<void> gettemp(String cityname) async {
    try {
      wedharstates = States.loding;
      Dio dio = Dio();
      dio.interceptors.add(
        LogInterceptor(
          error: true,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      );
      final response = await dio.get(
        URLs.urls,
        queryParameters: {
          "q": cityname,
          "units": "metric",
          "appid": KEYs.baseurl,
        },
      );
      data = Weather.fromJson(response.data);
      await Future.delayed(const Duration(seconds: 1));
      wedharstates = States.succses;
      citynameController.clear();
      Get.toNamed(Routes.WEATHERSHOW);
    } catch (e) {
      var message = e as DioError;
      wedharstates = States.error;
      Get.rawSnackbar(
        title: "Error",
        message: "${message.response?.data["message"]}",
      );
    }
  }
}
