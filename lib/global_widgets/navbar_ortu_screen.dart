// ignore_for_file: deprecated_member_use

import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/view/bill/screen/bill_screen.dart';
import 'package:educode/view/report/grade_report_screen.dart';
import 'package:educode/view/home/screen/home_screen.dart';
import 'package:educode/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBarOrtuScreen extends StatefulWidget {
  const NavBarOrtuScreen({super.key});

  @override
  State<NavBarOrtuScreen> createState() => _NavBarOrtuScreenState();
}

class _NavBarOrtuScreenState extends State<NavBarOrtuScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const GradeReportScreen(),
    const TagihanPembayaranScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
        selectedItemColor: ColorsConstant.primary300,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: ColorsConstant.neutral100,
        unselectedItemColor: ColorsConstant.neutral700,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SvgPicture.asset(
                _selectedIndex == 0
                    ? IconsConstant.homeNavOn
                    : IconsConstant.homeNavOff,
                color: ColorsConstant.primary300,
              ),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(
                _selectedIndex == 1
                    ? IconsConstant.reportNavOn
                    : IconsConstant.reportNavOff,
                color: ColorsConstant.primary300,
              ),
            ),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(
                _selectedIndex == 2
                    ? IconsConstant.billNavOn
                    : IconsConstant.billNavOff,
                color: ColorsConstant.primary300,
              ),
            ),
            label: 'Tagihan',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(
                _selectedIndex == 3
                    ? IconsConstant.profileNavOn
                    : IconsConstant.profileNavOff,
                color: ColorsConstant.primary300,
              ),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
