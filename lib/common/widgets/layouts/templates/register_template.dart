import 'package:absensi/common/styles/spacing_styles.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TRegisterTemplate extends StatelessWidget {
  const TRegisterTemplate({super.key, required this.child});


final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
      width: 550,
      child: SingleChildScrollView(
        child: Container(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            color: THelperFunctions.isDarkMode(context)? TColors.black:Colors.white,
          ),
          child: child,
        )
          ),
    ),
    );
          }
}