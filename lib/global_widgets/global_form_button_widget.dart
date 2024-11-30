import 'package:educode/utils/constants/color_constant.dart';
import 'package:educode/utils/constants/text_styles_constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class GlobalFormButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isFormValid;
  final bool isLoading;
  final double? buttonWidth;
  final double? buttonHeight;

  const GlobalFormButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.isLoading,
    this.isFormValid = false,
    this.buttonWidth = double.infinity,
    this.buttonHeight = 48,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isFormValid ? onTap : null,
      child: Ink(
        width: buttonWidth,
        height: buttonHeight,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isFormValid
              ? ColorsConstant.primary300
              : ColorsConstant.neutral200,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballBeat,
                    strokeWidth: 4.0,
                    colors: [Theme.of(context).secondaryHeaderColor],
                  ),
                ),
              )
            : Text(
                text,
                style: TextStylesConstant.nunitoCaption16.copyWith(
                  color: isFormValid
                      ? ColorsConstant.neutral100
                      : ColorsConstant.primary200,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
