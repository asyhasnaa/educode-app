import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:educode/utils/constants/color_constant.dart';

class TextStylesConstant {
  static final TextStyle _baseNunito = GoogleFonts.nunitoSans();

  static final TextStyle nunitoHeading32 = _baseNunito.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoHeading30 = _baseNunito.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoHeading24 = _baseNunito.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoHeading20 = _baseNunito.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoHeading18 = _baseNunito.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoHeading16 = _baseNunito.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle nunitoExtraBoldTitle = _baseNunito.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle nunitoTitleBold = _baseNunito.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoSemiboldTitle = _baseNunito.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle nunitoExtraBoldFooter = _baseNunito.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle nunitoSubtitle_1 = _baseNunito.copyWith(
    fontSize: 16,
    color: ColorsConstant.neutral500,
  );

  static final TextStyle nunitoSubtitle_2 = _baseNunito.copyWith(
    fontSize: 17,
    color: ColorsConstant.neutral600,
  );

  static final TextStyle nunitoSubtitle_3 = _baseNunito.copyWith(
    fontSize: 17,
    color: ColorsConstant.neutral600,
  );

  static final TextStyle nunitoSubtitle_4 = _baseNunito.copyWith(
    fontSize: 17,
    color: ColorsConstant.neutral900,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle nunitoCaption16 = _baseNunito.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle nunitoCaptionBold = _baseNunito.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle nunitoFooterBold = _baseNunito.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle nunitoFooterSemiBold = _baseNunito.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle nunitoFooter = _baseNunito.copyWith(
    fontSize: 12,
  );

  static final TextStyle nunitoButtonBold = _baseNunito.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle nunitoButtonMedium = _baseNunito.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle nunitoButtonSemibold = _baseNunito.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle nunitoButtonSmall = _baseNunito.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle nunitoReguler = _baseNunito.copyWith(
    fontSize: 14,
  );

  static final TextStyle nunitoCaptioReguler = _baseNunito.copyWith(
    fontSize: 12,
    color: ColorsConstant.neutral600,
  );
}
