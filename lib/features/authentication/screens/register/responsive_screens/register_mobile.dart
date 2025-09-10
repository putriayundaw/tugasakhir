// ignore: unused_import
import 'package:absensi/features/authentication/screens/login/widgets/login_header.dart';
import 'package:absensi/features/authentication/screens/register/widgets/register_form.dart';
import 'package:absensi/features/authentication/screens/register/widgets/register_header.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class RegisterScreenMobile extends StatelessWidget {
  const RegisterScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            //header
            TRegisterHeader(),

            //form
            TRegisterForm(),
          ],
        ),),
      ),
    );
  }
}