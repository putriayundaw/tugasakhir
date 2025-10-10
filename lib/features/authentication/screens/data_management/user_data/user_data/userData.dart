import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/responsive_screens/userData_Desktop.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/responsive_screens/userData_Mobile.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/responsive_screens/userData_Table.dart';
import 'package:flutter/material.dart';

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: UserDataDesktopScreen(), tablet: UserDataTabletScreen(), mobile: UserDataMobileScreen());
  }
}