import 'package:absensi/features/authentication/screens/forget_password/widgets/header_form.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreenMobile extends StatelessWidget {
  const ForgetPasswordScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(

        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: HeaderAndForm(),
        ),
      ),
    );
  }
}