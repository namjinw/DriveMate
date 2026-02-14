import 'package:drivemate/Controller/login.dart';
import 'package:drivemate/Model/user.dart';
import 'package:drivemate/Screen/slectCar.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userError = '';
  String passwordError = '';
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [SizedBox(height: 20), title(), form()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget title() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
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
      ),
      Image.asset(
        'assets/images/redcar.png',
        width: sizew(context) * 0.9,
        fit: BoxFit.cover,
      ),
      myText('로그인 정보를 입력하세요.', 16, white, FontWeight.w400),
    ],
  );

  Widget form() => Padding(
    padding: const EdgeInsets.only(top: 40, right: 30, left: 30, bottom: 20),
    child: Form(
      key: key,
      child: Column(
        children: [
          input(username, 'Username', Icons.person, false, (value) {
            String msg = '';
            if (value == null || value.isEmpty) {
              msg = '사용자 이름은 필수입니다.';
            } else if (value.length < 3) {
              msg = '사용자 이름은 4자 이상이여야 합니다.';
            }
            userError = msg;
            setState(() {});
            return null;
          }),
          SizedBox(height: 16),
          input(password, 'Password', Icons.lock, true, (value) {
            String msg = '';
            if (value == null || value.isEmpty) {
              msg = '비밀번호는 필수입니다.';
            } else if (value.length < 3) {
              msg = '비밀번호는 4자 이상이여야 합니다.';
            }
            passwordError = msg;
            setState(() {});
            return null;
          }),
          SizedBox(height: 20),
          toggle(),
          SizedBox(height: 15),
          button(
            () async {
              FocusScope.of(context).unfocus();
              key.currentState!.validate();
              print(userError);
              if (userError.isEmpty && passwordError.isEmpty) {
                final response = await LoginController.login(
                  LoginRequest(
                    username: username.text,
                    password: password.text,
                  ),
                );

                if (response != null) {
                  final userInfo = LoginResponse(
                    STATUS_CD: response.STATUS_CD,
                    token: response.token,
                    mberId: response.mberId,
                    mberNm: response.mberNm,
                  );
                  LoginController.user['token'] = response.token;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SelectCarScreen()),
                    (route) => true,
                  );
                } else {
                  showSnackBar(
                    context,
                    Icons.error_outline,
                    '아이디 또는 비밀번호가 다르니다.',
                  );
                }
              } else {
                showSnackBar(
                  context,
                  Icons.error_outline,
                  userError.isEmpty ? passwordError : userError,
                );
              }
            },
            [Colors.red, Colors.red.shade900],
            'Sign in',
            white,
            6,
            50,
          ),
          SizedBox(height: 80),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 25),
            child: Column(
              spacing: 15,
              children: [
                button(
                  () {
                    showSnackBar(
                      context,
                      Icons.error_outline,
                      '아직 준비줕인 기능입니다!',
                    );
                  },
                  [Colors.grey, Colors.grey],
                  'Sign Up',
                  white,
                  0,
                  45,
                ),
                button(
                  () {
                    showSnackBar(
                      context,
                      Icons.error_outline,
                      '아직 준비줕인 기능입니다!',
                    );
                  },
                  [white, white],
                  'Password Reset',
                  background,
                  0,
                  45,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget input(controller, label, icon, password, FormFieldValidator valid) =>
      Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: TextFormField(
            validator: valid,
            controller: controller,
            style: TextStyle(fontSize: 14),
            cursorColor: background,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(icon, color: Colors.grey, size: 28),
              isDense: true,
            ),
            maxLines: 1,
            obscureText: password,
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
