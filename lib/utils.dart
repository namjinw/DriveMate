import 'package:flutter/material.dart';

const background = Colors.black;
const homeBackground = Color(0xffffffff);
const myFont = 'Noto_Sans_KR';
const white = Colors.white;
const logoColor = Color(0xFFD39F8D);
const dialogColor = Color(0xfff1f1f1);
const textColor = Color(0xff656565);
const String BaseUrl = 'http://192.168.219.100:8000';
const Map<String, String> header = {
  'Content-Type': 'application/x-www-form-urlencoded',
};

Text myText(text, double size, color, weight) => Text(
  text,
  style: TextStyle(
    fontSize: size,
    color: color,
    fontFamily: myFont,
    fontWeight: weight,
  ),
);

double sizew(context) => MediaQuery.sizeOf(context).width;

double sizeh(context) => MediaQuery.sizeOf(context).height;

showSnackBar(context, icon, text) => ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Row(
      spacing: 10,
      children: [
        Icon(icon, color: Colors.grey),
        Text(text),
      ],
    ),
    duration: Duration(milliseconds: 1000),
  ),
);

myDialog(context, text) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    content: Container(
      height: 50,
      child: Center(
        child: myText(
          text,
          15,
          background,
          FontWeight.w700,
        ),
      ),
    ),
    actions: [
      Center(
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: myText('확인', 18, background, FontWeight.w700),
        ),
      ),
    ],
  ),
);
