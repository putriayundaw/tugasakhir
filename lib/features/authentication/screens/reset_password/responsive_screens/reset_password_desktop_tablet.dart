import 'package:absensi/common/widgets/layouts/templates/login_template.dart';
import 'package:absensi/features/authentication/screens/reset_password/widgets/reset_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ResetPasswordScreenDesktopTablet extends StatelessWidget {
  const ResetPasswordScreenDesktopTablet({super.key});

  @override
Widget build(BuildContext context) {
  final email = Get.parameters['email'] ?? '';

  return TLoginTemplate(
    child: ResetPasswordWidget(),
  );
}
}

