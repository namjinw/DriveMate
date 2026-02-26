import 'dart:convert';
import 'dart:io';

import 'package:drivemate/Model/car.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController {
  static late final SharedPreferences prefs;
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
  static bool inited = false;

  static Future<void> init() async {
    if (!inited) prefs = await SharedPreferences.getInstance();
    inited = true;

    await saveSelectedCar();
    await getSelectedCar();
  }

  static Future<void> saveSelectedCar() async {
    // 저장소 가져오기
    final json_car = jsonEncode(selectedCar.toJson()); // 객체를 json 할때 무조건 Key–Value 형태의 Map 구조로 변환
    await prefs.setString('car', json_car); // json 문자열 저장

    final image = await http.get(Uri.parse('${BaseUrl}${selectedCar.carImage}'));
    // 이미지는 byteArray 변환 후 넘기기

    try {
      final result = MethodChannel('kotlin').invokeMethod('getCar', {
        'carId': selectedCar.carId,
        'carNm': selectedCar.carNm,
        'carNo': selectedCar.carNo,
        'carImage': image.bodyBytes,
        'temperature': selectedCar.temperature,
        'weather': selectedCar.weather,
        'location': selectedCar.location,
        'drvngPosblDstnc': selectedCar.drvngPosblDstnc,
      });
      print('MethodChannel 전송 결과: $result');
    } catch(e) {
      print(e);
    }
  }

  static Future<void> getSelectedCar() async {
    final car = prefs.getString('car');
    if (car == null) return;
    final Map<String, dynamic> json = jsonDecode(car);
    selectedCar = Car.fromJson(json);
  }

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
