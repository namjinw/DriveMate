import 'package:drivemate/Screen/Component/registerCar.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectCarScreen extends StatefulWidget {
  const SelectCarScreen({super.key});

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  @override
  Widget build(BuildContext context) {
    final BuildContext parentContext = context;
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Image.asset('assets/images/car.png'),
                  button(
                    () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Registercar_Dialog();
                        },
                      );
                    },
                    [Colors.red, Colors.red.shade900],
                    '차량 등록 후 이용하기',
                    white,
                    6,
                    40,
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/cloud1.png', width: sizew(context)),
            Positioned(top: 100, right: 0, left: 0, child: title()),
          ],
        ),
      ),
    );
  }

  Widget title() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: 15,
    children: [
      SvgPicture.asset(
        'assets/images/logo.svg',
        width: 50,
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
      ),
      myText('Drive Mate', 30, white, FontWeight.w700),
    ],
  );

  Widget button(
    VoidCallback ontap,
    boxColor,
    text,
    textColor,
    double borderRadius,
    double height,
  ) => GestureDetector(
    onTap: ontap,
    child: Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: boxColor,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(child: myText(text, 16, textColor, FontWeight.w700)),
    ),
  );
}
