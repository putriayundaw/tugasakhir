import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:flutter/material.dart';

class TRegisterHeader extends StatelessWidget {
  const TRegisterHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
           const Image(width :110, height:110, image: AssetImage(TImages.darkAppLogo)),
            const SizedBox(height: 5),
           Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
           const SizedBox(height: TSizes.sm),
           Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

