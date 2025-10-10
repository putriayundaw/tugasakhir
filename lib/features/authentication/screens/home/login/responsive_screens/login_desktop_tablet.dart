import 'package:absensi/common/widgets/layouts/templates/login_template.dart';
import 'package:absensi/features/authentication/screens/home/login/widgets/login_form.dart';
import 'package:absensi/features/authentication/screens/home/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return  const TLoginTemplate( 
      child: Column(
            children: [
              //header
            TLoginHeader(),
              //form 
               TLoginForm(),
            ],
          ),
    );
  }
}

