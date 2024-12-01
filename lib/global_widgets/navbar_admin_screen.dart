// ignore_for_file: deprecated_member_use

import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/bill/screen/adm_list_bill_screen.dart';
import 'package:educode/view/home/screen/adm_home_screen.dart';
import 'package:educode/view/profile/adm_profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBarAdminScreen extends StatefulWidget {
  const NavBarAdminScreen({super.key});

  @override
  State<NavBarAdminScreen> createState() => _NavBarAdminScreenState();
}

class _NavBarAdminScreenState extends State<NavBarAdminScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    AdminHomeScreen(),
    const AdminInvoiceListPage(),
    const AdminProfileScreen(),
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
        selectedLabelStyle: TextStylesConstant.nunitoButtonBold,
        unselectedLabelStyle: TextStylesConstant.nunitoButtonBold.copyWith(
          color: ColorsConstant.neutral200,
        ),
        backgroundColor: ColorsConstant.neutral50,
        unselectedItemColor: ColorsConstant.primary200,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SvgPicture.asset(
                _selectedIndex == 0
                    ? IconsConstant.homeNavOn
                    : IconsConstant.homeNavOff,
                color: _selectedIndex == 0
                    ? ColorsConstant.primary300
                    : ColorsConstant.primary200,
              ),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(
                _selectedIndex == 1
                    ? IconsConstant.billNavOn
                    : IconsConstant.billNavOff,
                color: _selectedIndex == 1
                    ? ColorsConstant.primary300
                    : ColorsConstant.primary200,
              ),
            ),
            label: 'Tagihan',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.asset(
                _selectedIndex == 2
                    ? IconsConstant.profileNavOn
                    : IconsConstant.profileNavOff,
                color: _selectedIndex == 2
                    ? ColorsConstant.primary300
                    : ColorsConstant.primary200,
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
