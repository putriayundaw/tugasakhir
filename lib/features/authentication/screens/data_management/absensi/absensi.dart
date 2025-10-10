import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/screens.absensi/responsive_screen/absensi_desktop_screen.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/screens.absensi/responsive_screen/absensi_mobile_screen.dart';
import 'package:absensi/features/authentication/screens/data_management/absensi/screens.absensi/responsive_screen/absensi_tablet_screen.dart';
import 'package:flutter/material.dart';

class AbsensiScreen extends StatelessWidget {
  const AbsensiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  TSiteTemplate(desktop: AbsensiDesktopScreen(),tablet: AbsensiTabletScreen(),mobile: AbsensiMobileScreen());
  }
}