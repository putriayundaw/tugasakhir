import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class HeaderAndForm extends StatelessWidget {
  const HeaderAndForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header
        IconButton(
            onPressed: () => Get.offAllNamed(TRoutes.login), icon: const Icon(Iconsax.arrow_left)),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(TTexts.forgetPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(TTexts.forgetPasswordSubTitle,
            style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: TSizes.spaceBtwSections * 2),

        //form
        Form(
          child:TextFormField(
            decoration: const InputDecoration(
                labelText: TTexts.email,
                prefixIcon: Icon(Iconsax.direct_right)),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //submit button

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () => Get.toNamed(TRoutes.resetPassword,
                  parameters: {'email': 'otomasicerdas.com'}),
              child: const Text(TTexts.submit)),
        ),
        const SizedBox(height: TSizes.spaceBtwSections * 2),
      ],
    );
  }
}
