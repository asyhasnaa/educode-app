import 'package:educode/services/api_login_service.dart.dart';
import 'package:educode/services/api_profile_service.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile Pengguna',
            style: TextStylesConstant.nunitoHeading18,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/logo_educode.png')),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'Administrator',
                              style:
                                  TextStylesConstant.nunitoCaption16.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'educode@gmail.com',
                              style: TextStylesConstant.nunitoCaption16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: ColorsConstant.neutral100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              IconsConstant.profilEducode,
                              color: ColorsConstant.primary300,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tentang Kami',
                                    style: TextStylesConstant.nunitoCaptionBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pelajari lebih lanjut tentang layanan kami',
                                    style: TextStylesConstant.nunitoFooter,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                              IconsConstant.arrow_circle_right,
                              color: ColorsConstant.primary300,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: ColorsConstant.neutral100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              IconsConstant.layanan,
                              color: ColorsConstant.primary300,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Layanan Educode',
                                    style: TextStylesConstant.nunitoCaptionBold,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Panduan terkait penggunaan aplikasi',
                                    style: TextStylesConstant.nunitoFooter,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                              IconsConstant.arrow_circle_right,
                              color: ColorsConstant.primary300,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: ColorsConstant.neutral100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                IconsConstant.logout,
                                color: ColorsConstant.primary300,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Logout',
                                      style:
                                          TextStylesConstant.nunitoCaptionBold,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Keluar dari aplikasi',
                                      style: TextStylesConstant.nunitoFooter,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              SvgPicture.asset(
                                IconsConstant.arrow_circle_right,
                                color: ColorsConstant.primary300,
                              )
                            ],
                          ),
                        ),
                        onTap: () async {
                          ApiAuthService apiAuthService = ApiAuthService();

                          await apiAuthService.logout();

                          Get.off(() => LoginScreen());
                        },
                      ),
                    ]))));
  }
}
