import 'dart:io';

class Car {
  String carId;
  String carNm;
  String carNo;
  String carImage;
  String temperature;
  String weather;
  String location;

  Car({
    required this.carId,
    required this.carNm,
    required this.carNo,
    required this.carImage,
    required this.temperature,
    required this.weather,
    required this.location,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['carId'],
      carNm: json['carNm'],
      carNo: json['carNo'],
      carImage: json['carImage'],
      temperature: json['temperature'],
      weather: json['weather'],
      location: json['location'],
    );
  }
}

class CarResponse {
  final String STATUS_CD;
  final String message;
  final String carId;
  final String carNm;
  final String carNo;
  final String carImage;

  CarResponse({
    required this.STATUS_CD,
    required this.message,
    required this.carId,
    required this.carNm,
    required this.carNo,
    required this.carImage,
  });

  factory CarResponse.fromJson(Map<String, dynamic> json) {
    return CarResponse(
      STATUS_CD: json['STATUS_CD'],
      message: json['message'],
      carId: json['data']['carId'],
      carNm: json['data']['carNm'],
      carNo: json['data']['carNo'],
      carImage: json['data']['carImage'],
    );
  }
}
