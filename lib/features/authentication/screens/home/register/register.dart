import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/home/register/responsive_screens/register_desktop_tablet.dart';
import 'package:absensi/features/authentication/screens/home/register/responsive_screens/register_mobile.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(useLayout: false,desktop: RegisterScreenDesktopTablet(), mobile: RegisterScreenMobile());
  }
}