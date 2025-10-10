import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';

import 'package:absensi/features/authentication/screens/data_management/user_data/edit_userdata/widgets/edit_UserData_form.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class EditUserDataDesktopScreen extends StatelessWidget {
  const EditUserDataDesktopScreen({
    super.key,
    required this.user,
  });

  final UserModel user; 

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
                heading: 'Edit Data User',
                breadcrumbItems: [
                  TRoutes.editData,
                  'Edit User Data',
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              EditUserForm(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
