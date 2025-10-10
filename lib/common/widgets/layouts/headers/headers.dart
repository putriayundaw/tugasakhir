import 'package:absensi/common/widgets/shimmers/shimmer.dart';
import 'package:absensi/features/authentication/controller/home/login_controller.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';

class THeader extends GetView<LoginController> implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    // Pastikan data user tersedia saat header dibangun
    controller.ensureUserData();
    
    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TColors.white,
        elevation: 0,
        
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon: const Icon(Iconsax.menu),
              )
            : null,

        // Title dihapus (tidak ada search bar)
        title: null,

        actions: [
          // Icon notification
          IconButton(
            icon: const Icon(Iconsax.notification), 
            onPressed: () {}
          ),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          // Bagian User Info
          Obx(
            () {
              // Gunakan Obx untuk reactivity
              final userName = controller.getUserName();
              final userEmail = controller.getUserEmail();
              
              return Row(
                children: [
                  // Gambar profil
                  const TRoundedImage(
                    width: 40,
                    height: 40,
                    padding: 2,
                    imageType: ImageType.asset,
                    image: TImages.user,
                  ),
                  const SizedBox(width: TSizes.sm),

                  // Menampilkan nama dan email pengguna
                  if (!TDeviceUtils.isMobileScreen(context))
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          userEmail,
                          style: Theme.of(context).textTheme.labelMedium,
                        ), 
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}