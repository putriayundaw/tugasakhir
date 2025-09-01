import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';


class TAppBarTheme{
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(color: TColors.iconPrimary, size: TSizes.iconMd),
    actionsIconTheme: IconThemeData(color: TColors.iconPrimary, size: TSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: TColors.black, fontFamily: 'Urbanist'),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: TColors.dark,
    surfaceTintColor: TColors.dark,
    iconTheme: IconThemeData(color: TColors.black, size: TSizes.iconMd),
    actionsIconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: TColors.white, fontFamily: 'Urbanist'),
  );
}