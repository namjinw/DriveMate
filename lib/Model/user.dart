class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});
}

class LoginResponse {
  final String STATUS_CD;
  final String token;
  final String mberId;
  final String mberNm;

  LoginResponse({
    required this.STATUS_CD,
    required this.token,
    required this.mberId,
    required this.mberNm,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      STATUS_CD: json['STATUS_CD'],
      token: json['data']['token'],
      mberId: json['data']['mberId'],
      mberNm: json['data']['mberNm'],
    );
  }
}
