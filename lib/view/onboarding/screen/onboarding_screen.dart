import 'package:educode/global_widgets/global_button_widget.dart';
import 'package:educode/models/onboarding_model.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, top: 24),
                  child: Text(
                    'Skip',
                    style: TextStylesConstant.nunitoHeading18.copyWith(
                        color: ColorsConstant.primary300,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, i) {
                    return Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Image.asset(
                              contents[i].image,
                              height: 300,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: Text(
                                contents[i].title,
                                style: TextStylesConstant.nunitoHeading18,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 26,
                            ),
                            Flexible(
                              child: Text(
                                contents[i].description,
                                style: TextStylesConstant.nunitoCaption16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ));
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length, (index) => buildDot(index, context)),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: GlobalButtonWidget(
                buttonHeight: 50,
                onTap: () {
                  if (currentIndex == contents.length - 1) {
                    Get.to(() => LoginScreen()); //get replace
                  }
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear);
                },
                text: currentIndex == contents.length - 1
                    ? 'Masuk'
                    : 'Berikutnya',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 30 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == index
              ? ColorsConstant.primary300
              : ColorsConstant.neutral400),
    );
  }
}
