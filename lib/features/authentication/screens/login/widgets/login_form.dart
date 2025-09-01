import 'package:absensi/features/authentication/controller/login_controller.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
        key: controller.loginFormkey,
        child: Padding(
          padding:const  EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              //email
              TextFormField(
                controller: controller.email,
                validator:TValidator.validateEmail,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.email,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              //password
              Obx(
                ()=> TextFormField(
                  controller: controller.password,
                  validator: (value) => TValidator.validateEmptyText('Password',value),
                  obscureText: controller.hidePassword.value,
                  decoration: InputDecoration(
                    labelText: TTexts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                       onPressed: ()=> controller.hidePassword.value = !controller.hidePassword.value,
                       icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                   ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),

              //rememberme & forgot password

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //rememberme
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(()=> Checkbox(value: controller.rememberMe.value, onChanged: (value)=> controller.rememberMe.value = value!)),
                      const Text(TTexts.rememberMe),
                    ],
                  ),
                  //forgot password
                  TextButton(
                      onPressed: () => Get.toNamed(TRoutes.forgetPassword),
                      child: const Text(TTexts.forgetPassword)),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //sign in button

              SizedBox(
                width: double.infinity,
                // child: ElevatedButton(
                  //   onPressed: () => controller.emailAndPasswordSignIn() ,child: const Text(TTexts.signIn)),

                  child: ElevatedButton(
                    onPressed: () => controller.registerAdmin() ,child: const Text(TTexts.signIn)),
                    
              )
            ],
          ),
        ));
  }
}
