import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/icons..dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GlobalTextFieldWidget extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  final String? errorText;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? prefixIcon;
  final String? helperText;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool showSuffixIcon;
  final bool obscureText;
  final void Function()? onPressedSuffixIcon;
  final bool? enabled;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final TextStyle? errorStyle;

  const GlobalTextFieldWidget({
    super.key,
    this.focusNode,
    required this.controller,
    this.errorText,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.helperText,
    this.onChanged,
    this.onFieldSubmitted,
    this.showSuffixIcon = false,
    this.obscureText = false,
    this.onPressedSuffixIcon,
    this.enabled,
    required this.keyboardType,
    this.textAlign = TextAlign.start,
    this.errorStyle,
    String? initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
          ),
          child: TextFormField(
            textAlign: textAlign,
            focusNode: focusNode,
            controller: controller,
            obscureText: obscureText,
            style: TextStylesConstant.nunitoCaption16,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStylesConstant.nunitoCaptionBold.copyWith(
                color: ColorsConstant.neutral500,
              ),
              errorText: errorText,
              errorStyle: errorStyle,
              errorMaxLines: 2,
              contentPadding: EdgeInsets.symmetric(
                vertical: prefixIcon != null ? 8 : 12,
                horizontal: prefixIcon != null ? 0 : 12,
              ),
              isDense: true,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        prefixIcon!,
                        colorFilter: ColorFilter.mode(
                            (focusNode?.hasFocus ?? false) ||
                                    controller.text.isNotEmpty
                                ? ColorsConstant.primary300
                                : ColorsConstant.neutral500,
                            BlendMode.srcIn),
                      ),
                    )
                  : null,
              suffixIcon: showSuffixIcon
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: IconButton(
                        onPressed: onPressedSuffixIcon,
                        icon: SvgPicture.asset(
                          obscureText ? IconsConstant.hide : IconsConstant.show,
                          colorFilter: ColorFilter.mode(
                            (focusNode?.hasFocus ?? false) ||
                                    controller.text.isNotEmpty
                                ? ColorsConstant.primary300
                                : ColorsConstant.neutral500,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: controller.text.isNotEmpty
                      ? ColorsConstant.primary300
                      : ColorsConstant.neutral500,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: ColorsConstant.neutral800,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: ColorsConstant.danger500,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: ColorsConstant.danger500,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
            ),
            onChanged: onChanged,
            enabled: enabled,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: keyboardType,
          ),
        ),
        if (helperText != null && controller.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              helperText!,
              style: TextStylesConstant.nunitoFooterSemiBold.copyWith(
                color: ColorsConstant.neutral800,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
