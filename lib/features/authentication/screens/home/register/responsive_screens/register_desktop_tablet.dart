import 'package:absensi/common/widgets/layouts/templates/register_template.dart';
import 'package:absensi/features/authentication/screens/home/register/widgets/register_form.dart';
import 'package:absensi/features/authentication/screens/home/register/widgets/register_header.dart';
import 'package:flutter/material.dart';

class RegisterScreenDesktopTablet extends StatelessWidget {
  const RegisterScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return  const TRegisterTemplate( 
      child: Column(
            children: [
              //header
            TRegisterHeader(),
              //form 
               TRegisterForm(),
            ],
          ),
    );
  }
}

