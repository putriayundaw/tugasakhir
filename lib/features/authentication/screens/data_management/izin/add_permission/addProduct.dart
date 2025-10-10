import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/Models/permission_model.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/add_permission/responsive_screens/add_permission_Desktop.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/add_permission/responsive_screens/add_permission_Mobile.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/add_permission/responsive_screens/add_permission_Tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddPermissionScreen extends StatelessWidget {
  const AddPermissionScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    
    final permission = PermissionModel(id: 0, school: '', name: '', day: '', information: '');

    return  TSiteTemplate(
      desktop: AddPermissionDesktopScreen(permission:permission),
      tablet: AddPermissionTabletScreen(permission:permission),
      mobile: AddPermissionMobileScreen(permission:permission),
    );
  }
}