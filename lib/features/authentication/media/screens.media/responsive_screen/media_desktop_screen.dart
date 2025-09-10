import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/media/controllers/media_controller.dart';
import 'package:absensi/features/authentication/media/widgets/media_content.dart';
import 'package:absensi/features/authentication/media/widgets/media_uploader.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class MediaDesktopScreen extends StatelessWidget {
  const MediaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //breadcrumbs
                  const TBreadcrumbsWithHeading(
                    heading: 'Media', 
                    breadcrumbItems: [TRoutes.login, 'Media Screen']),

                  //toggleee images secton button
                  SizedBox(
                    width: TSizes.buttonWidth * 1.5,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.showImagesUploaderSection.value = !controller.showImagesUploaderSection.value,
                      icon: const Icon(Iconsax.cloud_add),
                      label: const Text('Upload Images'),
                    
                    ),
                  )
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections), 

                //upload area
                const MediaUploader(),

                //Media
                const MediaContent(),

            ],
          ),
        ),
      ),
    );
  }
}