import 'package:drivemate/Controller/login.dart';
import 'package:drivemate/Controller/register.dart';
import 'package:drivemate/Screen/Component/registerCar.dart';
import 'package:drivemate/Screen/home.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectCarScreen extends StatefulWidget {
  const SelectCarScreen({super.key});

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  bool check = false;

  final PageController carPageController = PageController();
  int pageIndex = 0;

  @override
  void dispose() {
    carPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext parentContext = context;
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RegisterController.car_list.isEmpty
            ? carRegister()
            : carSelect(),
      ),
    );
  }

  Widget carSelect() => Stack(
    children: [
      SizedBox.expand(),
      Image.asset('assets/images/cloud1.png', width: sizew(context)),
      Positioned(top: 100, right: 0, left: 0, child: title()),
      catSelectedMenu(),
    ],
  );

  Widget catSelectedMenu() => Positioned(
    left: 0,
    right: 0,
    bottom: 130,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        carPage(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: myText(
            RegisterController.car_list[pageIndex].carNm,
            20,
            white,
            FontWeight.w700,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: carMenu(),
        ),
      ],
    ),
  );

  Widget carMenu() => Column(
    spacing: 15,
    children: [
      toggle(),
      SizedBox(height: 15),
      button(
        () async {
          await RegisterController.oneGetCar(LoginController.user['token']!, RegisterController.car_list[pageIndex].carId);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        },
        [Colors.red, Colors.red.shade900],
        '이 차량 선택하기',
        white,
        6,
        45,
        Alignment.topCenter,
        Alignment.bottomCenter,
      ),
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
        [Color(0xff1c1c1c), Colors.black, Color(0xff1c1c1c)],
        '차량 등록 하기',
        logoColor,
        6,
        45,
        Alignment.centerLeft,
        Alignment.centerRight,
      ),
    ],
  );

  Widget carPage() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: () {
          if (pageIndex > 0) {
            pageIndex--;
            carPageController.animateToPage(
              pageIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {});
          }
        },
        icon: Icon(Icons.arrow_back_ios_new),
        color: white,
      ),
      Expanded(
        child: SizedBox(
          height: 120,
          child: PageView.builder(
            controller: carPageController,
            itemBuilder: (context, index) =>
                catItem(RegisterController.car_list[index], index),
            itemCount: RegisterController.car_list.length,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
      IconButton(
        onPressed: () {
          if (pageIndex < RegisterController.car_list.length - 1) {
            pageIndex++;
            carPageController.animateToPage(
              pageIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {});
          }
        },
        icon: Icon(Icons.arrow_forward_ios),
        color: white,
      ),
    ],
  );

  Widget catItem(car, index) => Container(
    width: sizew(context),
    height: 120,
    child: Center(
      child: Image.network(
        '${BaseUrl}${car.carImage}',
        width: sizew(context),
        height: sizeh(context),
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget toggle() => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 15,
    children: [
      GestureDetector(
        onTap: () => setState(() {
          check = !check;
        }),
        child: Container(
          width: 45,
          height: 24,
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Container(
                width: double.infinity,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withAlpha(90),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              AnimatedPositioned(
                left: check ? 21 : 0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Color(0xffcf8e6e),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      myText('Remember', 16, white, FontWeight.w400),
    ],
  );

  Widget carRegister() => Stack(
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
              Alignment.topCenter,
              Alignment.bottomCenter,
            ),
          ],
        ),
      ),
      Image.asset('assets/images/cloud1.png', width: sizew(context)),
      Positioned(top: 100, right: 0, left: 0, child: title()),
    ],
  );

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
    begin,
    end,
  ) => GestureDetector(
    onTap: ontap,
    child: Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: begin, end: end, colors: boxColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(child: myText(text, 16, textColor, FontWeight.w700)),
    ),
  );
}
