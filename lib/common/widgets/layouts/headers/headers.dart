import 'package:absensi/common/widgets/shimmers/shimmer.dart';
import 'package:absensi/features/authentication/controller/user_controller.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;  // Mengambil instance dari UserController

    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan leading default
        backgroundColor: TColors.white,
        elevation: 0,
        
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon: const Icon(Iconsax.menu),
              )
            : null,

        title: TDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.search_normal),
                    hintText: 'Search anything...',
                  ),
                ),
              )
            : null,

        actions: [
          if (!TDeviceUtils.isDesktopScreen(context))
            IconButton(icon: const Icon(Iconsax.search_normal), onPressed: () {}),

          IconButton(icon: const Icon(Iconsax.notification), onPressed: () {}),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          Row(
            children: [
              // Gambar profil dengan TRoundedImage widget
              Obx(
                () => TRoundedImage(
                  width: 40,
                  height: 40,
                  padding: 2,
                  imageType: controller.user.value.profilePicture.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : TImages.user,  // Gambar default jika tidak ada foto profil
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Menampilkan nama dan email pengguna
              if (!TDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const TShimmerEffect(width: 40, height: 13)
                          : Text(
                              controller.user.value.name.isNotEmpty
                                  ? controller.user.value.name  // Nama pengguna
                                  : 'Username',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                      Text(
                        controller.user.value.email.isNotEmpty
                            ? controller.user.value.email  // Email pengguna
                            : 'Email',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
