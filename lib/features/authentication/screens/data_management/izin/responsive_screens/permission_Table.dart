import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/izin_controller.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/table/data_table.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/widgets/table_header.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PermissionTabletScreen extends StatelessWidget {
  const PermissionTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
        final IzinController izinController = Get.put(IzinController());

       return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding:  const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const TBreadcrumbsWithHeading(heading: 'Permission', breadcrumbItems: ['Permission']),
             const SizedBox(height: TSizes.spaceBtwItems),

            TRoundedContainer(
              child: Column(
                children: [
                  TAddPermissionTableHeader(
                    buttonText: 'Add New Permission',
                    onPressed: () => Get.toNamed(TRoutes.addPermission),
                    searchOnChanged: (String query) => izinController.searchPermissions(query),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  const AddPermissionTable(),
                ],
              ),
            ),
          ],
        ),),
      ),
    );
  }
}