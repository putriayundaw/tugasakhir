import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/dashboard/responsive_screens/dashboard_desktop.dart';
import 'package:absensi/features/authentication/screens/dashboard/responsive_screens/dashboard_mobile.dart';
import 'package:absensi/features/authentication/screens/dashboard/responsive_screens/dashboard_tablet.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  TSiteTemplate(desktop: DashboardDesktopScreen(),tablet: DashboardTabletScreen(),mobile: DashboardMobileScreen());
  }
}