import 'package:absensi/common/widgets/images/t_circular_image.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape:const  BeveledRectangleBorder(),
      child: Container(
        decoration:const BoxDecoration(
          color: TColors.white,
          border: Border(
            right: BorderSide(color: TColors.grey,width: 1),
          )
        ),

        child: SingleChildScrollView(
          child: Column(
            //image
            children: [
              TCircularImage(width: 110, height: 110, image: TImages.darkAppLogo, backgroundColor: Colors.transparent),
              SizedBox(height: TSizes.spaceBtwSections),
              Padding(padding: EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('MENU', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                

                //menu item
                // const TMenuItem(route: TRoutes.firstScreen, icon: Iconsax.status, itemName: 'Dashboard'),
                // const TMenuItem(route:TRoutes. secoundScreen, icon: Iconsax.image, itemName: 'Media'),
                // const TMenuItem(route:TRoutes. responsiveDesignScreen, icon: Iconsax.picture_frame, itemName: 'Banners'),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}

