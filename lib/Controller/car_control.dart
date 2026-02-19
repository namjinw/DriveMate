import 'dart:convert';

import 'package:drivemate/utils.dart';
import 'package:http/http.dart';

class CarController {
  static String strtgYn = 'N';
  static String doorYn = 'N';
  static String wndwYn = 'N';
  static String emgncLmpYn = 'N';

  static Future<String> startCar(String token, String carId) async {

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/strtg'),
        headers: controllHeader(token),
          body: jsonEncode({
            'strtgYn': strtgYn != 'Y' ? 'Y' : 'N'
          })
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['strtgYn'];
        strtgYn = data;
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> FuckingOpenThDoor(String token, String carId) async {
    try {
      final response = await put(
          Uri.parse('${BaseUrl}/api/car/${carId}/door'),
          headers: controllHeader(token),
          body: jsonEncode({
            'doorYn': doorYn != 'Y' ? 'Y' : 'N'
          })
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['doorYn'];
        doorYn = data;
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> WindowComputerBooting(String token, String carId) async {
    try {
      final response = await put(
          Uri.parse('${BaseUrl}/api/car/${carId}/wndw'),
          headers: controllHeader(token),
          body: jsonEncode({
            'wndwYn': wndwYn != 'Y' ? 'Y' : 'N'
          })
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['wndwYn'];
        wndwYn = data;
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> startEmgncLmp(String token, String carId) async {
    try {
      final response = await put(
          Uri.parse('${BaseUrl}/api/car/${carId}/emgncLmp'),
          headers: controllHeader(token),
          body: jsonEncode({
            'emgncLmpYn': emgncLmpYn != 'Y' ? 'Y' : 'N'
          })
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['emgncLmpYn'];
        emgncLmpYn = data;
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }
}