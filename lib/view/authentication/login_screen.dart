import 'package:educode/global_widgets/global_form_button_widget.dart';
import 'package:educode/global_widgets/global_text_field_widget.dart';
import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';

import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:educode/view_model/authentication/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsConstant.neutral50,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Center(
                      child: Image.asset(
                    "assets/images/onboarding1.png",
                    width: 250,
                  )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masuk',
                        style: TextStylesConstant.nunitoHeading24,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email/Username',
                        style: TextStylesConstant.nunitoCaption16,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => GlobalTextFieldWidget(
                          focusNode: loginController.usernameFocusNode,
                          controller: loginController.usernameController,
                          errorText: loginController.emailErrorText.value,
                          hintText: 'Masukkan Email atau Username',
                          prefixIcon: IconsConstant.message,
                          showSuffixIcon: false,
                          helperText: 'Contoh : sarah@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Kata Sandi',
                        style: TextStylesConstant.nunitoCaption16,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => GlobalTextFieldWidget(
                          focusNode: loginController.passwordFocusNode,
                          controller: loginController.passwordController,
                          errorText: loginController.passwordErrorText.value,
                          hintText: 'Masukkan Kata Sandi Anda',
                          prefixIcon: IconsConstant.lock,
                          showSuffixIcon: true,
                          obscureText: loginController.obscureText.value,
                          onChanged: (value) =>
                              loginController.validatePassword(value),
                          onPressedSuffixIcon: () =>
                              loginController.toggleObscureText(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Masuk Sebagai',
                        style: TextStylesConstant.nunitoCaption16,
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: ColorsConstant.neutral500)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton(
                                underline: Container(
                                  color: Colors.transparent,
                                ),
                                value: loginController
                                        .selectedRole.value.isNotEmpty
                                    ? loginController.selectedRole.value
                                    : null,
                                hint: Text(
                                  'Pilih Peran Anda',
                                  style: TextStylesConstant.nunitoCaption16
                                      .copyWith(
                                          color: ColorsConstant.neutral500),
                                ),
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: ColorsConstant.neutral400),
                                items: <String>[
                                  'Admin',
                                  'Orangtua',
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStylesConstant.nunitoCaption16,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  loginController.selectedRole.value =
                                      newValue!;
                                }),
                          )),
                      const SizedBox(height: 30),
                      Obx(
                        () => GlobalFormButtonWidget(
                          text: 'Masuk',
                          isFormValid: loginController.isFormValid.value,
                          onTap: loginController.isFormValid.value
                              ? loginController.postLogin
                              : null,
                          isLoading: loginController.isLoading.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
