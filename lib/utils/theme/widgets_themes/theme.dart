import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/theme/widgets_themes/appbar_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/bottom_sheet_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/checkbox_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/chip_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/elevated_button_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/outlined_button_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/text_field_theme.dart';
import 'package:absensi/utils/theme/widgets_themes/text_theme.dart';
import 'package:flutter/material.dart';




class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: TColors.grey,
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: TColors.primaryBackground,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: TColors.grey,
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    scaffoldBackgroundColor: TColors.primary.withOpacity(0.1),
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
