import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/Models/permission_model.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/add_permission/widgets/add_permission_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';


class AddPermissionMobileScreen extends StatelessWidget {
  const AddPermissionMobileScreen({    super.key,
    required this.permission, 
  });

  final PermissionModel permission; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'AddPermission',
                breadcrumbItems: [
                  TRoutes.addPermission,
                  'Add Permission'
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              AddPermissionForm(),
            ],
          ),
        ),
      ),
    );
  }
}
