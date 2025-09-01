import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        /// Header
        Row(
          children: [
            IconButton(
              onPressed: () => Get.offAllNamed(TRoutes.login),
              icon: const Icon(CupertinoIcons.clear),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
    
        /// Image
        const Image(
          image: AssetImage(TImages.deliveredEmailIllustration),
          width: 300,
          height: 300,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
    
        /// Title & Subtitle
        Text(
          TTexts.changeYourPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
    
        Text(
          TTexts.email,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
    
        Text(
          TTexts.changeYourPasswordSubTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
    
        const SizedBox(height: TSizes.spaceBtwSections),
    
        //buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: ()=>Get.offAllNamed(TRoutes.login), child: const Text(TTexts.done)),
        ),
         SizedBox(
          width: double.infinity,
          child: TextButton(onPressed: (){}, child: const Text(TTexts.resendEmail)),
        )
      ],
    );
  }
}