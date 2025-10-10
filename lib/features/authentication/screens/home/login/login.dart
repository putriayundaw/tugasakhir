

import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/home/login/responsive_screens/login_desktop_tablet.dart';
import 'package:absensi/features/authentication/screens/home/login/responsive_screens/login_mobile.dart';
import 'package:flutter/material.dart';

class LoginScrenn extends StatelessWidget {
  const LoginScrenn({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(useLayout: false,desktop: LoginScreenDesktopTablet(), mobile: LoginScreenMobile());
  }
}