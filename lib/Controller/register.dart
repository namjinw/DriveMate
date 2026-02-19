import 'dart:convert';
import 'dart:io';

import 'package:drivemate/Model/car.dart';
import 'package:drivemate/utils.dart';
import 'package:http/http.dart' as http;

class RegisterController {
  static List<Car> car_list = [];
  static Car selectedCar = Car(
    carId: '',
    carNm: '',
    carNo: '',
    carImage: '',
    temperature: '',
    weather: '',
    location: '',
    drvngPosblDstnc: 0
  );

  static Future<CarResponse?> carUpload(
    String CarNm,
    String CarNo,
    File file,
    String token,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${BaseUrl}/api/car'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['carNm'] = CarNm;
      request.fields['carNo'] = CarNo;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamed = await request.send(); // 실제 HTTP 요청을 서버로 전송하는 동작
      // 그런데 여기서 바로 Response가 오는 게 아니라 StreamedResponse가 옴 <= (파일 업로드)
      // → StreamedResponse

      // 일반 post()
      // final response = await http.post(...);
      // → 바로 Response

      final response = await http.Response.fromStream(streamed);
      // treamedResponse를 일반 Response 객체로 변환하는 과정

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return CarResponse.fromJson(json);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> GetCar(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${BaseUrl}/api/car"),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];
        car_list = data.map((e) => Car.fromJson(e)).toList();
      } else {
        car_list = [];
      }
    } catch (e) {
      car_list = [];
    }
  }

  static Future<void> oneGetCar(String token, String carId) async {
    try {
      final response = await http.get(
        Uri.parse("${BaseUrl}/api/car/${carId}"),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final dynamic data = json['data'];
        selectedCar = Car.fromJson(data);
      } else {
        car_list = [];
      }
    } catch (e) {
      car_list = [];
    }
  }
}
