import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/izin_controller.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/table/data_table.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class PermissionMobileScreen extends StatelessWidget {
  const PermissionMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final IzinController izinController = Get.find<IzinController>();
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                heading: 'Permission',
                breadcrumbItems: ['Permission']
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.toNamed(TRoutes.addPermission),
                            icon: const Icon(Iconsax.add),
                            label: const Text('Add New Permission'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        TextFormField(
                          onChanged: (String query) => izinController.searchPermissions(query),
                          decoration: InputDecoration(
                            hintText: 'Search Names',
                            prefixIcon: const Icon(Iconsax.search_normal),
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            suffixIcon: IconButton(
                              onPressed: () => izinController.searchPermissions(''),
                              icon: const Icon(Iconsax.close_circle, size: 16),
                              tooltip: 'Clear Search',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    const AddPermissionTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
