import 'package:absensi/common/widgets/layouts/templates/login_template.dart';
import 'package:absensi/features/authentication/screens/home/forget_password/widgets/header_form.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreenDesktopTablet extends StatelessWidget {
  const ForgetPasswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: HeaderAndForm(),
    );
    }
}

