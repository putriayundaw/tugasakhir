import 'package:absensi/common/widgets/images/t_circular_image.dart';
import 'package:absensi/common/widgets/layouts/sidebars/menu/menu_item.dart';
import 'package:absensi/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:absensi/features/authentication/controller/home/login_controller.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());
    final loginController = Get.find<LoginController>();

    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(
            right: BorderSide(color: TColors.grey, width: 1),
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TCircularImage(
                width: 120, 
                height: 120, 
                image: TImages.darkAppLogo, 
                backgroundColor: Colors.transparent
              ),
              const SizedBox(height: TSizes.xs),
              Padding(
                padding: EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    Text('MENU', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    const TMenuItem(route: TRoutes.dashboard, icon: Iconsax.status, itemName: 'Dashboard'),

                    
                    Text('Product', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    
                    
                    Obx(() {
                      final userRole = loginController.getUserRole().toLowerCase();
                      if (userRole == 'admin') {
                        return const TMenuItem(route: TRoutes.addProduct, icon: Iconsax.box, itemName: 'Add Product');
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    
                    
                    const TMenuItem(route: TRoutes.allProduct, icon: Iconsax.car, itemName: 'All Product'),

                    
                    Obx(() {
                      final userRole = loginController.getUserRole().toLowerCase();
                      
                      if (userRole == 'admin') {
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('History', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                            const TMenuItem(route: TRoutes.inStock, icon: Iconsax.login, itemName: 'In Stock'),
                            const TMenuItem(route: TRoutes.outStock, icon: Iconsax.logout, itemName: 'Out Stock'),
                            const TMenuItem(route: TRoutes.borrowedProduct, icon: Iconsax.card, itemName: 'Borrowed'),
                            const TMenuItem(route: TRoutes.returnedProduct, icon: Iconsax.bag, itemName: 'Returned'),
                          ],
                        );
                      } else {
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('History', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                            const TMenuItem(route: TRoutes.borrowedProduct, icon: Iconsax.card, itemName: 'Borrowed'),
                            const TMenuItem(route: TRoutes.returnedProduct, icon: Iconsax.bag, itemName: 'Returned'),
                          ],
                        );
                      }
                    }),

                    
                    Obx(() {
                      final userRole = loginController.getUserRole().toLowerCase();
                      
                      if (userRole == 'admin') {
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data Management', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                            const TMenuItem(route: TRoutes.absensi, icon: Iconsax.user, itemName: 'Attendance'),
                            const TMenuItem(route: TRoutes.izin, icon: Iconsax.book, itemName: 'Permission'),
                            const TMenuItem(route: TRoutes.userData, icon: Iconsax.user, itemName: 'Users'),
                          ],
                        );
                      } else {
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data Management', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                            const TMenuItem(route: TRoutes.izin, icon: Iconsax.book, itemName: 'Permission'),

                          ],
                        );
                      }
                    }),
                    
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi Logout'),
                                content: const Text('Apakah Anda yakin ingin logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                            
                            if (shouldLogout == true) {
                              await loginController.logout();
                            }
                          },
                          onHover: (hovering) => hovering
                              ? menuController.changeHoverItem(TRoutes.login)
                              : menuController.changeHoverItem(''),
                          child: Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: menuController.isHovering(TRoutes.login) ||
                                          menuController.isActive(TRoutes.login)
                                      ? TColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: TSizes.lg,
                                          top: TSizes.md,
                                          bottom: TSizes.md,
                                          right: TSizes.md),
                                      child: menuController.isActive(TRoutes.login)
                                          ? Icon(Iconsax.logout_1, size: 22, color: TColors.white)
                                          : Icon(Iconsax.logout_1,
                                              size: 22,
                                              color: menuController.isHovering(TRoutes.login)
                                                  ? TColors.white
                                                  : TColors.darkGrey),
                                    ),
                                    
                                    if (menuController.isHovering(TRoutes.login) ||
                                        menuController.isActive(TRoutes.login))
                                      Flexible(
                                          child: Text('Logout',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .apply(color: TColors.white)))
                                    else
                                      Flexible(
                                          child: Text('Logout',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .apply(color: TColors.darkGrey))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}