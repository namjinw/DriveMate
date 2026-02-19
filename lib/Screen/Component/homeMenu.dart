import 'dart:async';

import 'package:drivemate/Controller/car_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Controller/login.dart';
import '../../Controller/register.dart';
import '../../utils.dart';

class Homemenu extends StatefulWidget {
  const Homemenu({super.key});

  @override
  State<Homemenu> createState() => _HomemenuState();
}

class _HomemenuState extends State<Homemenu> {
  String start = '';
  String door = '';
  String window = '';
  String exit = '';

  Timer? colorTimer;
  bool colorChange = false;

  void startColorTimer() {
    colorTimer?.cancel();
    colorTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!mounted) return;
      colorChange = !colorChange;
      setState(() {});
    });
  }

  void stopColorTimer() {
    colorTimer?.cancel();
    colorTimer = null;
    colorChange = false;
  }

  Color iconColor(String on, emergency, colorChange) {
    if (on != 'Y') return background;
    if (emergency == false) return white;

    return colorChange ? Colors.red : white;
  }

  final ScrollController button_scroll = ScrollController();

  @override
  void dispose() {
    colorTimer?.cancel();
    super.dispose();
  }

  double floatBottom = 150;

  DateTime? lastRefreshTime;

  Future<void> Refresh() async {
    final now = DateTime.now();

    if (lastRefreshTime != null &&
        now.difference(lastRefreshTime!) < Duration(seconds: 2)) {
      print(now.difference(lastRefreshTime!));
      showSnackBar(context, Icons.access_time, '잠시 후 새로고침을 해주세요.');
      // difference: 기준 시각으로부터 얼마나 지나는지 구하는 함수
      return;
    }

    lastRefreshTime = now;

    await RegisterController.oneGetCar(
      LoginController.user['token']!,
      RegisterController.selectedCar.carId,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    button_scroll.addListener(() {
      print(button_scroll.offset);
      floatBottom = 130 - button_scroll.offset;
      floatBottom.clamp(-30, 130);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: Refresh,

            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: button_scroll,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: carState(),
                  ),
                  SizedBox(height: 50),
                  Image.network(
                    BaseUrl + RegisterController.selectedCar.carImage,
                  ),
                  SizedBox(height: 50),
                  carButton(),
                  SizedBox(height: 25),
                  carControl(),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: floatBottom,
            right: 20,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOutBack,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: white, blurRadius: 8)],
                gradient: RadialGradient(
                  colors: [background, Color(0xff3c3c3c), background],
                  stops: [0.4, 0.9, 1.0],
                ),
              ),
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 0,
                backgroundColor: Colors.transparent,
                shape: CircleBorder(),
                child: Icon(
                  Icons.power_settings_new_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget carButton() => Row(
    spacing: 20,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      carButtonItem(
        '시동',
        'power_settings_new_24dp_5F6368_FILL0_wght300_GRAD200_opsz24.svg',
        () async {
          final response = await CarController.startCar(
            LoginController.user['token']!,
            RegisterController.selectedCar.carId,
          );
          start = response;
          setState(() {});
          showSnackBar(
            context,
            start == 'Y'
                ? Icons.settings_power_sharp
                : Icons.power_settings_new_outlined,
            start == "Y" ? '시동이 켜졌습니다.' : '시동이 꺼졌습니다.',
          );
        },
        start,
      ),
      carButtonItem(
        '도어',
        'lock_24dp_5F6368_FILL0_wght400_GRAD0_opsz24.svg',
        () async {
          final response = await CarController.FuckingOpenThDoor(
            LoginController.user['token']!,
            RegisterController.selectedCar.carId,
          );
          door = response;
          setState(() {});
          showSnackBar(
            context,
            door == 'Y' ? Icons.sensor_door : Icons.sensor_door_outlined,
            door == "Y" ? '도어가 열렸습니다.' : '도어가 닫혔습니다.',
          );
        },
        door,
      ),
      carButtonItem('창문', 'car-door-svgrepo-com.svg', () async {
        final response = await CarController.WindowComputerBooting(
          LoginController.user['token']!,
          RegisterController.selectedCar.carId,
        );
        window = response;
        setState(() {});
        showSnackBar(
          context,
          window == 'Y' ? Icons.width_full_outlined : Icons.width_full,
          window == "Y" ? '창문이 열렸습니다.' : '창문이 닫혔습니다.',
        );
      }, window),
      carButtonItem(
        '비상문',
        'warning_24dp_5F6368_FILL0_wght300_GRAD200_opsz24.svg',
        () async {
          final response = await CarController.startEmgncLmp(
            LoginController.user['token']!,
            RegisterController.selectedCar.carId,
          );
          exit = response;
          if (exit == "Y") {
            startColorTimer();
          } else {
            stopColorTimer();
          }
          setState(() {});
          showSnackBar(
            context,
            exit == "Y"
                ? Icons.report_gmailerrorred_sharp
                : Icons.report_off_outlined,
            exit == "Y" ? '비상문이 열렸습니다.' : '비상문이 닫혔습니다.',
          );
        },
        exit,
        emerdency: true,
        colorChange: colorChange,
      ),
    ],
  );

  Widget carButtonItem(
    text,
    svg,
    VoidCallback ontap,
    on, {
    emerdency = false,
    colorChange = false,
  }) => GestureDetector(
    onTap: ontap,
    child: Column(
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: on == 'Y' ? background : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 2,
                  color: on == 'Y' ? background : Colors.grey,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/$svg',
                  width: 35,
                  colorFilter: ColorFilter.mode(
                    iconColor(on, emerdency, colorChange),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
        myText(text, 16, background, FontWeight.w400),
      ],
    ),
  );

  Widget carControl() => Container(
    width: sizew(context),
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myText(
          '${LoginController.user['mberNm']!}님, 안녕하세요?',
          18,
          background,
          FontWeight.w700,
        ),
        SizedBox(height: 15),
        controlMenu(),
        SizedBox(height: 95),
      ],
    ),
  );

  Widget controlMenu() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Container(
      width: sizew(context),
      height: 270,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          controlItem('car-svgrepo-com.svg', 'Vehicle control', () {}),
          controlItem('ventilating-fan-svgrepo-com.svg', 'Climate', () {}),
          controlItem('my_location.svg', 'Location', () {}),
          controlItem('vpn_key_black_24dp.svg', 'Valet Mode', () {}),
        ],
      ),
    ),
  );

  Widget controlItem(svg, title, ontap) => GestureDetector(
    onTap: ontap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: sizew(context),
      height: 55,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: logoColor.withAlpha(70)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/$svg',
                height: 25,
                colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
              ),
              SizedBox(width: 15),
              myText(title, 16, white, FontWeight.w400),
            ],
          ),
          Icon(Icons.arrow_forward_ios_outlined, color: white, size: 15),
        ],
      ),
    ),
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
          stateItem(
            'local_gas.svg',
            RegisterController.selectedCar.drvngPosblDstnc.toString() + 'km',
            RegisterController.selectedCar.drvngPosblDstnc < 50
                ? Colors.red
                : (RegisterController.selectedCar.drvngPosblDstnc <= 100
                      ? Color(0xff0206ff)
                      : background),
          ),
        ],
      ),
      SizedBox(height: 6),
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
      SizedBox(width: 5),
      myText(text, 16, color, FontWeight.w400),
    ],
  );
}
