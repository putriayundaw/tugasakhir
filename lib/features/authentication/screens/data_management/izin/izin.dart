import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/responsive_screens/permission_Desktop.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/responsive_screens/permission_Mobile.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/responsive_screens/permission_Table.dart';
import 'package:flutter/material.dart';

class IzinScreen extends StatelessWidget {
  const IzinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  TSiteTemplate(desktop: PermissionDesktopScreen(),tablet: PermissionTabletScreen(),mobile: PermissionMobileScreen());
  }
}