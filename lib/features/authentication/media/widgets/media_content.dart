import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/media/controllers/media_controller.dart';
import 'package:absensi/features/authentication/media/widgets/folder_dropdown.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MediaContent extends StatelessWidget {
  const MediaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return  TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //media images header
          Row(children: [
            Text('Select Folder', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: TSizes.spaceBtwItems),
            MediaFolderDropdown(onChanged: (MediaCategory? newValue){
              if (newValue != null){
                controller.selectedPath.value = newValue;
              }
            },)
          ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),



        //show media
        const Wrap(
                    alignment: WrapAlignment.start,
                   spacing: TSizes.spaceBtwItems /2,
                   runSpacing: TSizes.spaceBtwItems /2,
                   children: [
                    TRoundedImage(
                      width: 90,
                      height: 90,
                      padding: TSizes.sm,
                      imageType : ImageType.asset,
                      image: TImages.darkAppLogo,
                      backgroundColor: TColors.primaryBackground,
                    ),
                    TRoundedImage(
                      width: 90,
                      height: 90,
                      padding: TSizes.sm,
                      imageType : ImageType.asset,
                      image: TImages.darkAppLogo,
                      backgroundColor: TColors.primaryBackground,
                    ),
                    TRoundedImage(
                      width: 90,
                      height: 90,
                      padding: TSizes.sm,
                      imageType : ImageType.asset,
                      image: TImages.darkAppLogo,
                      backgroundColor: TColors.primaryBackground,
                    ),
                    TRoundedImage(
                      width: 90,
                      height: 90,
                      padding: TSizes.sm,
                      imageType : ImageType.asset,
                      image: TImages.darkAppLogo,
                      backgroundColor: TColors.primaryBackground,
                    ),
                    TRoundedImage(
                      width: 90,
                      height: 90,
                      padding: TSizes.sm,
                      imageType : ImageType.asset,
                      image: TImages.darkAppLogo,
                      backgroundColor: TColors.primaryBackground,
                    ),
                    TRoundedImage(
                      width: 90,
                      height: 90,
                      padding: TSizes.sm,
                      imageType : ImageType.asset,
                      image: TImages.darkAppLogo,
                      backgroundColor: TColors.primaryBackground,
                    ),
                   ],
                   ),


        //loding more media button
        Padding(padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: TSizes.buttonWidth,
              child: ElevatedButton.icon(onPressed: (){}, label: const Text('Load More'),
              icon: const Icon(Iconsax.arrow_down),
              ),
            )
          ],
        ),)
        ],
      ),
    );
  }
}