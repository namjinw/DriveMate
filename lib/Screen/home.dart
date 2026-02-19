import 'dart:async';

import 'package:drivemate/Controller/login.dart';
import 'package:drivemate/Controller/register.dart';
import 'package:drivemate/Screen/Component/controlMenu.dart';
import 'package:drivemate/Screen/Component/homeMenu.dart';
import 'package:drivemate/Screen/slectCar.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Component/shareMenu.dart';
import 'Component/statusMenu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomIndex = 0;

  final List<Widget> pages = [
    Homemenu(),
    Controlmenu(),
    Statusmenu(),
    Sharemenu(),
  ];

  final clouds = ['assets/images/cloud2.png', 'assets/images/cloud3.png'];

  final slideController = PageController(initialPage: 99);

  bool runAnim = true;

  Future autoCloud() async {
    while (mounted && runAnim) {
      if (!slideController.hasClients) {
        // PageView에 연결되어 있는지확인
        // 연결 되어 있지 않다면 기다리고 다음으로 가기
        await Future.delayed(Duration(milliseconds: 50));
        continue;
      }
      await slideController.nextPage(
        duration: const Duration(seconds: 15),
        curve: Curves.linear,
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      autoCloud();
    });

    super.initState();
  }

  @override
  void dispose() {
    runAnim = false;
    slideController.dispose();
    super.dispose();
  }

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
                  stops: [0.0, 0.45, 0.55, 1.0],
                  colors: [Color(0xffaaaaaa), Color(0xff818181), white, white],
                ),
              ),
            ),
          ),
          cloud(),
          IndexedStack(index: bottomIndex, children: pages),
          bottomBar(),
        ],
      ),
    );
  }

  Widget cloud() => Positioned(
    left: 0,
    top: 0,
    right: 0,
    child: Container(
      width: sizew(context),
      height: 320,
      alignment: Alignment.topCenter,
      child: PageView.builder(
        controller: slideController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Image.asset(
          clouds[index % clouds.length],
          width: sizew(context),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );

  AppBar appBar() => AppBar(
    backgroundColor: Colors.transparent,
    title: SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [appBarLeft(), appBarRight()],
          ),
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
      alarmButton(),
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

  Widget alarmButton() => Stack(
    children: [
      IconButton(
        onPressed: () {
          if (RegisterController.selectedCar.drvngPosblDstnc < 50) {
            showSnackBar(context, Icons.notifications, '주행가능 거리가 50km미만 입니다.');
          } else {
            showSnackBar(context, Icons.notifications_none, '새로운 알림이 없습니다.');
          }
        },
        icon: SvgPicture.asset(
          'assets/images/notifications.svg',
          width: 30,
          colorFilter: ColorFilter.mode(background, BlendMode.srcIn),
        ),
      ),
      Positioned(
        right: 7,
        top: 7,
        child: IgnorePointer(
          ignoring: true,
          child: Opacity(
            opacity: RegisterController.selectedCar.drvngPosblDstnc < 50 ? 1 : 0,

            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('N', style: TextStyle(color: white, fontSize: 10)),
              ),
            ),
          ),
        ),
      ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              bottomItem(icon: Icons.home_outlined, text: 'Home', index: 0),
              bottomLine(),
              bottomItem(
                icon: Icons.control_camera_outlined,
                text: 'Control',
                index: 1,
              ),
              bottomLine(),
              bottomItem(
                text: 'Status',
                svg: 'directions_car.svg',
                useSvg: true,
                index: 2,
              ),
              bottomLine(),
              bottomItem(
                text: 'Share',
                svg: 'device_hub_black_24dp.svg',
                useSvg: true,
                index: 3,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget bottomItem({icon, text, svg, useSvg = false, required int index}) =>
      GestureDetector(
        onTap: () => setState(() => bottomIndex = index),
        child: Column(
          children: [
            useSvg
                ? SvgPicture.asset(
                    'assets/images/${svg}',
                    width: 35,
                    colorFilter: ColorFilter.mode(
                      bottomIndex == index ? logoColor : textColor,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    icon,
                    color: bottomIndex == index ? logoColor : textColor,
                    size: 35,
                  ),
            myText(
              text,
              15,
              bottomIndex == index ? logoColor : textColor,
              FontWeight.w400,
            ),
          ],
        ),
      );

  Widget bottomLine() => Container(
    width: 1,
    height: 45,
    decoration: BoxDecoration(color: Colors.grey),
  );
}
