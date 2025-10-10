import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/home/forget_password/responsive_screens/forget_password_desktop_tablet.dart';
import 'package:absensi/features/authentication/screens/home/forget_password/responsive_screens/forget_password_mobile.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(useLayout: false, desktop: ForgetPasswordScreenDesktopTablet(),mobile: ForgetPasswordScreenMobile());
  }
}