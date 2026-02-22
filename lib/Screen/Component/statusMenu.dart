import 'package:drivemate/Controller/car_control.dart';
import 'package:drivemate/Model/carStatus.dart';
import 'package:drivemate/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Controller/login.dart' show LoginController;
import '../../Controller/register.dart';

class Statusmenu extends StatefulWidget {
  const Statusmenu({super.key});

  @override
  State<Statusmenu> createState() => _StatusmenuState();
}

class _StatusmenuState extends State<Statusmenu> {
  String door = '';

  Future<void> statusToggle(
    Future<String> Function(String, String) action,
    onIcon,
    offIcon,
    String onMessage,
    String offMessage,
  ) async {
    final response = await action(
      LoginController.user['token']!,
      RegisterController.selectedCar.carId,
    );
    final isOn = response == 'Y';
    showSnackBar(
      context,
      isOn ? onIcon : offIcon,
      isOn ? onMessage : offMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CarController.carStatus,
      builder: (context, status, child) => DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            children: [
              tabBar(),
              Expanded(
                child: TabBarView(
                  children: [carStatus(status), carAirConditioning(status)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget carStatus(CarStatus status) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 14, top: 24, bottom: 12),
        child: myText('차량 상태', 18, background, FontWeight.w700),
      ),
      statusList(status),
    ],
  );

  Widget carAirConditioning(CarStatus status) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 14, top: 24, bottom: 12),
        child: myText('공조 상태', 18, background, FontWeight.w700),
      ),
      AirConfitionList(status),
    ],
  );

  statusList(CarStatus status) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      spacing: 5,
      children: [
        statusItem(
          '도어',
          'door2.svg',
          status.doorYn == 'Y' ? '열림' : '잠김',
          status.doorYn == 'Y' ? logoColor : background,
          () => statusToggle(
            CarController.FuckingOpenThDoor,
            Icons.sensor_door,
            Icons.sensor_door_outlined,
            '도어가 열렸습니다.',
            '도어가 닫혔습니다.',
          ),
        ),
        statusItem(
          '창문',
          'window.svg',
          status.wndwYn == 'Y' ? '열림' : '닫힘',
          status.wndwYn == 'Y' ? logoColor : background,
          () => statusToggle(
            CarController.WindowComputerBooting,
            Icons.width_full_outlined,
            Icons.width_full,
            '도어가 열렸습니다.',
            '도어가 닫혔습니다.',
          ),
        ),
        statusItem(
          '테일게이트',
          'tailgate.svg',
          status.tailgateYn == 'Y' ? '열림' : '닫힘',
          status.tailgateYn == 'Y' ? logoColor : background,
          () => statusToggle(
            CarController.funcKingOpenTailgate,
            Icons.car_rental,
            Icons.car_rental_outlined,
            '테일게이트가 열렸습니다.',
            '테일게이트가 닫혔습니다.',
          ),
        ),
        statusItem(
          '후드',
          'bonnet.svg',
          status.hoodYn == 'Y' ? '열림' : '닫힘',
          status.hoodYn == 'Y' ? logoColor : background,
          () => statusToggle(
            CarController.funcKingOpenHood,
            Icons.build_circle,
            Icons.build_circle_outlined,
            '후드가 열렸습니다.',
            '후드가 닫혔습니다.',
          ),
        ),
      ],
    ),
  );

  Widget AirConfitionList(CarStatus status) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      spacing: 5,
      children: [
        HeatItem(
          '낸/난방',
          'mode_cool_24dp_5F6368_FILL0_wght300_GRAD200_opsz24.svg',
          status.cdysmYn == 'Y' ? '켜집' : '꺼짐',
          status.cdysmYn == 'Y' ? logoColor : background,
          status.cdysmYn == 'Y' ? Colors.red : background,
          () => statusToggle(
            CarController.HeatCdy,
            Icons.ac_unit,
            Icons.exit_to_app,
            '낸/난방이 켜졌습니다.',
            '낸/난방이 꺼졌습니다.',
          ),
          Alignment.topCenter,
          useHeat: false,
        ),
        HeatItem(
          '핸들 열선',
          'handle.svg',
          status.handleYn == 'Y' ? '켜집' : '꺼짐',
          status.handleYn == 'Y' ? logoColor : background,
          status.handleYn == 'Y' ? Colors.red : background,
          () => statusToggle(
            CarController.Heathandle,
            Icons.sports_baseball,
            Icons.sports_baseball_outlined,
            '핸들 열선이 켜졌습니다.',
            '핸들 열선이 꺼졌습니다.',
          ),
          Alignment.topCenter,
          useRotate: false,
        ),
        HeatItem(
          '앞유리 성에 제거',
          'mirror-svgrepo-com.svg',
          status.frontmirrorYn == 'Y' ? '켜집' : '꺼짐',
          status.frontmirrorYn == 'Y' ? logoColor : background,
          status.frontmirrorYn == 'Y' ? Colors.red : background,
          () => statusToggle(
            CarController.Haetfrontmirror,
            Icons.local_fire_department,
            Icons.local_fire_department_outlined,
            '앞유리 성에 제거가 켜졌습니다.',
            '앞유리 성에 제거가 꺼졌습니다.',
          ),
          Alignment.topCenter,
          useRotate: true,
        ),
        HeatItem(
          '뒷유리 성에 제거',
          'mirror-svgrepo-com.svg',
          status.backmirrorHeatYn == 'Y' ? '켜집' : '꺼짐',
          status.backmirrorHeatYn == 'Y' ? logoColor : background,
          status.backmirrorHeatYn == 'Y' ? Colors.red : background,
          () => statusToggle(
            CarController.Heatbackmirror,
            Icons.local_fire_department,
            Icons.local_fire_department_outlined,
            '뒷유리 성에 제거가 켜졌습니다.',
            '뒷유리 성에 제거가 꺼졌습니다.',
          ),
          Alignment.bottomCenter,
          useRotate: true,
        ),
        HeatItem(
          '사이드 미러 열선',
          'side mirror.svg',
          status.sidemirrorHeatYn == 'Y' ? '켜집' : '꺼짐',
          status.sidemirrorHeatYn == 'Y' ? logoColor : background,
          status.sidemirrorHeatYn == 'Y' ? Colors.red : background,
          () => statusToggle(
            CarController.Heatsidemirror,
            Icons.thermostat,
            Icons.thermostat_auto,
            '사이드 미러 열선이 켜졌습니다.',
            '사이드 미러 열선이 꺼졌습니다.',
          ),
          Alignment.topCenter,
        ),
      ],
    ),
  );

  Widget statusItem(text, svg, status, color, ontap) => Container(
    height: 65,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: background.withAlpha(40)),
      ),
    ),
    child: ListTile(
      onTap: ontap,
      leading: SvgPicture.asset(
        'assets/images/$svg',
        height: 35,
        width: 35,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: background,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: myText(status, 16, color, FontWeight.w400),
    ),
  );

  Widget HeatItem(
    text,
    svg,
    status,
    color,
    heatColor,
    ontap,
    align, {
    useHeat = true,
    useRotate = false,
  }) => Container(
    height: 65,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: background.withAlpha(40)),
      ),
    ),
    child: ListTile(
      onTap: ontap,
      leading: Container(
        width: 30,
        height: 35,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: useRotate ? 1.55 : 0,
                child: SvgPicture.asset(
                  'assets/images/$svg',
                  height: 35,
                  width: 35,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ),
            Align(
              alignment: align,
              child: SvgPicture.asset(
                'assets/images/heat.svg',
                width: 20,
                colorFilter: ColorFilter.mode(
                  useHeat == true ? heatColor : Colors.transparent,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: background,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: myText(status, 16, color, FontWeight.w400),
    ),
  );

  Widget tabBar() => TabBar(
    labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
    labelColor: logoColor,
    indicatorColor: logoColor,
    indicatorWeight: 2,
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: Colors.transparent,
    tabs: [
      Tab(text: '차량'),
      Tab(text: '공조'),
    ],
  );
}
