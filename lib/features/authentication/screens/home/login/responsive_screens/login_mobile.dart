import 'package:absensi/features/authentication/screens/home/login/widgets/login_form.dart';
import 'package:absensi/features/authentication/screens/home/login/widgets/login_header.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class LoginScreenMobile extends StatelessWidget {
  const LoginScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            //header
            TLoginHeader(),

            //form
            TLoginForm(),
          ],
        ),),
      ),
    );
  }
}