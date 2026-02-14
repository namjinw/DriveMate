import 'dart:convert';

import 'package:drivemate/Model/user.dart';
import 'package:drivemate/utils.dart';
import 'package:http/http.dart';

class LoginController {
  static Map<String, String> user = {'mberNm': '', 'mberId': '', 'token': ''};

  static Future<LoginResponse?> login(LoginRequest request) async {
    try {
      final response = await post(
        Uri.parse('${BaseUrl}/api/authenticate/signin'),
        headers: header,
        body: {'mberId': request.username, 'mberPassword': request.password},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return LoginResponse.fromJson(json);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
