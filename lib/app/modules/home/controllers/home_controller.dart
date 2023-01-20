import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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

  final _wedharstates = States.initial.obs;
  States get wedharstates => _wedharstates.value;
  set wedharstates(States value) => _wedharstates.value = value;

  final dio = Dio();

  @override
  void onInit() {
    setUpDio();
    super.onInit();
  }

  void setUpDio() {
    try {
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getWeatherDataByCity(String cityname) async {
    try {
      wedharstates = States.loding;

      final response = await dio.get(
        URLs.urls,
        queryParameters: {
          "q": cityname,
          "units": "metric",
          "appid": KEYs.keys,
        },
      );
      data = Weather.fromJson(response.data);
      await Future.delayed(const Duration(seconds: 1));
      wedharstates = States.succses;
      citynameController.clear();
      wedharstates = States.initial;
      Get.toNamed(Routes.WEATHERSHOW);
    } catch (e) {
      var message = e as DioError;
      wedharstates = States.error;
      Get.rawSnackbar(
        title: "Error",
        message: "${message.response?.data["message"]}",
      );
      wedharstates = States.initial;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getWeatherDataByLatLong() async {
    try {
      wedharstates = States.loding;
      final position = await _determinePosition();
      final response = await dio.get(
        URLs.urls,
        queryParameters: {
          "lat": position.latitude,
          "lon": position.longitude,
          "units": "metric",
          "appid": KEYs.keys,
        },
      );
      data = Weather.fromJson(response.data);
      citynameController.clear();
      wedharstates = States.succses;
      Get.toNamed(Routes.WEATHERSHOW);
    } on DioError catch (err) {
      citynameController.clear();
      Get.rawSnackbar(title: "Error", message: err.response?.data["message"]);
      wedharstates = States.error;
    } on MissingPluginException catch (e) {
      Get.rawSnackbar(title: "Error", message: e.message);
      wedharstates = States.error;
    } catch (e) {
      citynameController.clear();
      Get.rawSnackbar(title: "Error", message: e.toString());
      wedharstates = States.error;
    }
  }
}
