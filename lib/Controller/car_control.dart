import 'dart:convert';

import 'package:drivemate/Model/carStatus.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class CarController {
  static final ValueNotifier<CarStatus> carStatus = ValueNotifier(
    CarStatus(
      strtgYn: 'N',
      doorYn: 'N',
      wndwYn: 'N',
      emgncLmpYn: 'N',
      tailgateYn: 'N',
      hoodYn: 'N',
      cdysmYn: 'N',
      handleYn: 'N',
      frontmirrorYn: 'N',
      backmirrorHeatYn: 'N',
      sidemirrorHeatYn: 'N',
    ),
  );

  static Future<String> startCar(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/strtg'),
        headers: controllHeader(token),
        body: jsonEncode({'strtgYn': status.strtgYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['strtgYn'];
        carStatus.value  = status.copyWith(strtgYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> FuckingOpenThDoor(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/door'),
        headers: controllHeader(token),
        body: jsonEncode({'doorYn': status.doorYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['doorYn'];
        carStatus.value  = status.copyWith(doorYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> WindowComputerBooting(
    String token,
    String carId,
  ) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/wndw'),
        headers: controllHeader(token),
        body: jsonEncode({'wndwYn': status.wndwYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['wndwYn'];
        carStatus.value  = status.copyWith(wndwYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> startEmgncLmp(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/emgncLmp'),
        headers: controllHeader(token),
        body: jsonEncode({'emgncLmpYn': status.emgncLmpYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['emgncLmpYn'];
        carStatus.value  = status.copyWith(emgncLmpYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> funcKingOpenTailgate(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/tailgate'),
        headers: controllHeader(token),
        body: jsonEncode({'tailgateYn': status.tailgateYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['tailgateYn'];
        carStatus.value  = status.copyWith(tailgateYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> funcKingOpenHood(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/hood'),
        headers: controllHeader(token),
        body: jsonEncode({'hoodYn': status.hoodYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['hoodYn'];
        carStatus.value  = status.copyWith(hoodYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> HeatCdy(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/cdysm'),
        headers: controllHeader(token),
        body: jsonEncode({'cdysmYn': status.cdysmYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['cdysmYn'];
        carStatus.value = status.copyWith(cdysmYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> Heathandle(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/handle'),
        headers: controllHeader(token),
        body: jsonEncode({'handleYn': status.handleYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['handleYn'];
        carStatus.value = status.copyWith(handleYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> Haetfrontmirror(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/frontmirror'),
        headers: controllHeader(token),
        body: jsonEncode({'frontmirrorYn': status.frontmirrorYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['frontmirrorYn'];
        carStatus.value = status.copyWith(frontmirrorYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> Heatbackmirror(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/backmirrorHeat'),
        headers: controllHeader(token),
        body: jsonEncode({'backmirrorHeatYn': status.backmirrorHeatYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['backmirrorHeatYn'];
        carStatus.value = status.copyWith(backmirrorHeatYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }

  static Future<String> Heatsidemirror(String token, String carId) async {
    final status = carStatus.value;

    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/car/${carId}/sidemirrorHeat'),
        headers: controllHeader(token),
        body: jsonEncode({'sidemirrorHeatYn': status.sidemirrorHeatYn != 'Y' ? 'Y' : 'N'}),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jons = jsonDecode(response.body);
        final String data = jons['data']['sidemirrorHeatYn'];
        carStatus.value = status.copyWith(sidemirrorHeatYn: data);
        return data;
      } else {
        return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
      }
    } catch (e) {
      return '서버 오류가 발생했습니다. 다시 시도해 주십시오';
    }
  }
}
