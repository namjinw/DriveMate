import 'package:drivemate/Screen/loginForm.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool logoIconShow = false;
  bool mainSimbolTextShow = false;
  bool subbnSimbolTextShow = false;
  bool carShow = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500));
      logoIconShow = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 1000));
      mainSimbolTextShow = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 800));
      subbnSimbolTextShow = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 1000));
      carShow = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Logo(), SizedBox(height: 90), Car()],
          ),
        ),
      ),
    );
  }

  Widget Logo() => Column(spacing: 10, children: [logoIcon(), simbolTitle()]);

  Widget logoIcon() => AnimatedOpacity(
    opacity: logoIconShow ? 1 : 0,
    duration: Duration(milliseconds: 800),
    child: AnimatedRotation(
      turns: logoIconShow ? 0 : 0.3,
      curve: Curves.easeInOutBack,
      duration: Duration(milliseconds: 900),
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 95,
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
      ),
    ),
  );

  Widget simbolTitle() => Container(
    height: 120,
    child: Column(
      spacing: 10,
      children: [
        AnimatedPadding(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsetsGeometry.only(right: mainSimbolTextShow ? 0 : 35),
          child: AnimatedOpacity(
            opacity: mainSimbolTextShow ? 1 : 0,
            duration: Duration(milliseconds: 600),
            child: myText('Drive Mate', 32, white, FontWeight.w700),
          ),
        ),
        AnimatedPadding(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsetsGeometry.only(top: subbnSimbolTextShow ? 0 : 20),
          child: AnimatedOpacity(
            opacity: subbnSimbolTextShow ? 1 : 0,
            duration: Duration(milliseconds: 550),
            child: myText('연결하고, 운전하고, 즐기세요', 20, white, FontWeight.w400),
          ),
        ),
      ],
    ),
  );

  Widget Car() => AnimatedOpacity(
    opacity: carShow ? 1 : 0,
    duration: Duration(milliseconds: 500),
    child: Image.asset('assets/images/car.png', width: sizew(context), fit: BoxFit.cover),
  );
}
