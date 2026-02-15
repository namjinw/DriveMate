import 'dart:io';

import 'package:drivemate/Controller/login.dart';
import 'package:drivemate/Controller/register.dart';
import 'package:drivemate/Model/car.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Registercar_Dialog extends StatefulWidget {
  const Registercar_Dialog({super.key});

  @override
  State<Registercar_Dialog> createState() => _Registercar_DialogState();
}

class _Registercar_DialogState extends State<Registercar_Dialog> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController carName = TextEditingController();
  final TextEditingController carNum = TextEditingController();
  String CarNameErr = '';
  String CarNumErr = '';

  File? seletImage;
  final ImagePicker picker = ImagePicker();

  // XFile은 image_picker 패키지에서 사용하는 파일 추상 객체
  // final XFile? image = await picker.pickImage(...)
  // 여기서 pickImage()의 반환 타입이 Future<XFile?>
  // XFile 안에는 뭐가 들어있냐?
  //  image.path      // 파일 경로
  //  image.name      // 파일 이름
  //  image.mimeType  // MIME 타입
  //  image.length()  // 파일 크기
  //  image.readAsBytes()

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source, // 이미지 구한 곳 (갤러리, 사진)
      maxWidth: 600, // 사진 크기
      maxHeight: 600,
      imageQuality: 80, // 이미지 해상도
    );

    if (image != null) {
      seletImage = File(image.path);
      // XFile → dart:io File 바꾸기
      setState(() {});
    }
  }

  @override
  void dispose() {
    carName.dispose();
    carNum.dispose();
    super.dispose();
  }

  // ImagePicker는
  // 📱 운영체제(안드로이드/iOS)의 카메라 앱이나 갤러리 앱을 호출하는 브릿지(중간 다리) 역할

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: sizew(context),
        height: 525,
        decoration: BoxDecoration(
          color: dialogColor.withAlpha(240),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        child: Column(
          spacing: 20,
          children: [
            topmenu(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: form(),
            ),
          ],
        ),
      ),
    );
  }

  Widget topmenu() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      myText('차량등록하기', 20, background, FontWeight.w700),
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset(
          'assets/images/cancel.svg',
          width: 30,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(background, BlendMode.srcIn),
        ),
      ),
    ],
  );

  Widget form() => Form(
    key: key,
    child: Column(
      spacing: 15,
      children: [
        input(carName, '차량이름', 'assets/images/directions_car.svg', false, (
          value,
        ) {
          String err = '';
          if (value == null || value.isEmpty) {
            err = '차량 이름을 입력해 주세요.';
          }
          CarNameErr = err;
          setState(() {});
          return null;
        }, 40),
        input(carNum, '차량번호', 'assets/images/pin.svg', false, (value) {
          String err = '';
          if (value == null || value.isEmpty) {
            err = '차량 번호을 입력해 주세요.';
          }
          CarNumErr = err;
          setState(() {});
          return null;
        }, 40),
        selectImage(),
        SizedBox(height: 5),
        button(),
      ],
    ),
  );

  Widget selectImage() => Column(
    children: [
      GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return Container(
                width: sizew(context),
                height: 120,
                color: white,
                child: Row(
                  children: [
                    selectButton(
                      Icons.image_search,
                      '갤러리',
                      () {
                        pickImage(ImageSource.gallery);
                        Navigator.pop(context);
                        },
                    ),
                    selectButton(
                      Icons.camera_alt,
                      '카메라',
                      () {
                        pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          width: sizew(context),
          height: 130,
          decoration: BoxDecoration(color: dialogColor),
          child: seletImage != null
              ? Image.file(
                  seletImage!,
                  width: sizew(context),
                  height: sizeh(context),
                  fit: BoxFit.contain,
                )
              : emptyImaga(),
        ),
      ),
      SizedBox(height: 8),
      myText('이미지를 선택해 주세요.', 16, textColor, FontWeight.w400),
      myText('갤러리 앱 또는 카메라를 이용하실 수 잇습니다', 16, textColor, FontWeight.w400),
    ],
  );

  Widget selectButton(icon, text, VoidCallback onpressed) => Expanded(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      onPressed: onpressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 50),
          myText(text, 20, background, FontWeight.w700),
        ],
      ),
    ),
  );

  Widget emptyImaga() => Center(
    child: SvgPicture.asset(
      'assets/images/image.svg',
      width: 40,
      fit: BoxFit.cover,
    ),
  );

  Widget button() => GestureDetector(
    onTap: () async {
      FocusScope.of(context).unfocus();
      key.currentState!.validate();

      if (CarNumErr.isNotEmpty || CarNameErr.isNotEmpty) {
        myDialog(context, CarNumErr.isEmpty ? CarNameErr : CarNumErr);
      } else if (seletImage == null) {
        myDialog(context, '이미지가 선택되지 않았습니다.');
      }

      if (CarNumErr.isEmpty && CarNameErr.isEmpty && seletImage != null) {
        final response = await RegisterController.carUpload(carName.text, carNum.text, seletImage!, LoginController.user['token']!);

        if (response != null && response.STATUS_CD == 'S') {
          await RegisterController.GetCar(LoginController.user['token']!);
          Navigator.pop(context);
          showSnackBar(context, Icons.directions_car, response.message);
        } else {
          showSnackBar(context, Icons.directions_car, '차량 등록에 실패했습니다.');
        }
      }
    },
    child: Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.red.shade700, Colors.red.shade900],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: myText('차량 등록 후 이용하기', 16, white, FontWeight.w700)),
    ),
  );

  Widget input(
    controller,
    label,
    icon,
    password,
    FormFieldValidator valid,
    double size,
  ) => Container(
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
        style: TextStyle(fontSize: 15),
        cursorColor: background,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 8.0),
            child: SvgPicture.asset(icon, width: 30, fit: BoxFit.cover),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: size),
          isDense: true,
        ),
        maxLines: 1,
        obscureText: password,
      ),
    ),
  );
}
