import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class THeader extends StatelessWidget implements PreferredSizeWidget{
  const THeader({super.key, this.scaffoldKey});

  //globsl key
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1))
      ),
      padding:const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        //mobile menu
        leading:!TDeviceUtils.isDesktopScreen(context) ?IconButton(onPressed: () => scaffoldKey?.currentState?.openDrawer(), icon:const Icon(Iconsax.menu)): null,

        //search 
        title: TDeviceUtils.isDesktopScreen(context)
        ? SizedBox(
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: 'Search anything...'),
          ),
      )
      :null,

      //actions
      actions: [
        if(!TDeviceUtils.isDesktopScreen(context)) IconButton(icon: const Icon(Iconsax.search_normal), onPressed: (){}),

        IconButton(icon: const Icon(Iconsax.notification),onPressed: (){}),
        const SizedBox(width: TSizes.spaceBtwItems/2),

        //user data
         Row(  
          children: [
          TRoundedImage(
            width: 40,
            padding: 2,
            height: 40,
            imageType: ImageType.asset,
            image:TImages.user,
          ),


          const SizedBox(width: TSizes.sm),


          //nama dan email
          if(!TDeviceUtils.isMobileScreen(context))
          Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OCN', style: Theme.of(context).textTheme.titleLarge),
              Text('otomasicerdasnusantara.com',style: Theme.of(context).textTheme.labelMedium),
            ],
          ),

        ],
        ),
      ],
      ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}