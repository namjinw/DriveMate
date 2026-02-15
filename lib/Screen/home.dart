import 'package:drivemate/Controller/register.dart';
import 'package:drivemate/Screen/slectCar.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: appBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.686, 0.795, 1.0],
                  colors: [Color(0xffaaaaaa), Color(0xff818181), white, white],
                ),
              ),
              child: SafeArea(child: Column()),
            ),
          ),
          bottomBar(),
        ],
      ),
    );
  }

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    toolbarHeight: 125,
    title: SizedBox(
      height: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [appBarLeft(), appBarRight()],
          ),
          carState(),
        ],
      ),
    ),
  );

  Widget appBarLeft() => GestureDetector(
    onTap: () => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SelectCarScreen()),
      (route) => false,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        myText(
          RegisterController.selectedCar.carNm,
          25,
          background,
          FontWeight.w700,
        ),
        SizedBox(width: 4),
        Icon(Icons.arrow_forward_ios, size: 18),
      ],
    ),
  );

  Widget appBarRight() => Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      SizedBox(width: 4),
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          'assets/images/notifications.svg',
          width: 30,
          colorFilter: ColorFilter.mode(background, BlendMode.srcIn),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          'assets/images/settings.svg',
          width: 30,
          colorFilter: ColorFilter.mode(background, BlendMode.srcIn),
        ),
      ),
    ],
  );

  Widget carState() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          stateItem(
            'sunny.svg',
            RegisterController.selectedCar.temperature,
            background,
          ),
          stateItem('local_gas.svg', RegisterController.selectedCar.weather, background),
        ],
      ),
      SizedBox(height: 6,),
      stateItem(
        'my_location.svg',
        RegisterController.selectedCar.location,
        background,
      ),
    ],
  );

  Widget stateItem(String img, text, color) => Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic,
    children: [
      SvgPicture.asset(
        'assets/images/$img',
        width: 25,
        colorFilter: ColorFilter.mode(background, BlendMode.srcIn),
      ),
      SizedBox(width: 5,),
      myText(text, 16, color, FontWeight.w400),
    ],
  );

  Widget bottomBar() => Positioned(
    bottom: 0,
    right: 0,
    left: 0,
    child: Container(
      width: sizew(context),
      height: 75,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        border: Border(top: BorderSide(color: Colors.grey, width: 1)),
      ),
    ),
  );
}
