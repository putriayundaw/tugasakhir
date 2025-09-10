import 'package:absensi/common/widgets/texts/page_heading.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class TBreadcrumbsWithHeading extends StatelessWidget {
  const TBreadcrumbsWithHeading({super.key, required this.heading, required this.breadcrumbItems,  this.returnToPreviousScreen = false,});

final String heading;

final List<String> breadcrumbItems;

final bool returnToPreviousScreen;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //breadcrumbtail
        
        Row(
          children: [
            //dashboard link
            InkWell(
              onTap: ()=> Get.offAllNamed(TRoutes.dashboard),
              child: Padding(padding: const EdgeInsets.all(TSizes.xs),
                     child:  Text('Dashbord',
              style: Theme.of(context).textTheme.bodySmall!.apply(fontWeightDelta:-1),
              ),
              ),
            ),

          for (int i = 0; i< breadcrumbItems.length; i++)
            Row(
              children: [
                const Text('/'),//sperator
                InkWell(
                  //
                  onTap: i == breadcrumbItems.length - 1 ? null:() => Get.offAllNamed(TRoutes.dashboard),
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.xs),
                  child: Text(i == breadcrumbItems.length - 1? breadcrumbItems[i].capitalize.toString(): capitalize(breadcrumbItems[i].substring(1)), style: Theme.of(context).textTheme.bodySmall!.apply(fontWeightDelta: -1)),
                  ),
                )
              ],
            ),
            
          ],
        ),
        const SizedBox(height: TSizes.sm),

        //heading o the page
        Row(
          children: [
           if (returnToPreviousScreen) IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
           if (returnToPreviousScreen)const SizedBox(width: TSizes.spaceBtwItems),
           TPageHeading(heading: heading)
          ],
        )
      ],
    );
  }
  String capitalize(String s){
    return s.isEmpty?'': s[0].toUpperCase()+ s.substring(1);

  }
}