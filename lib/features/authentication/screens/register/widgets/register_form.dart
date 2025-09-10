import 'package:absensi/features/authentication/controller/register_controller.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TRegisterForm extends StatelessWidget {
  const TRegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return Form(
      key: controller.registerFormKey, // GlobalKey untuk validasi
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Nama
            TextFormField(
              controller: controller.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: TTexts.users,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Email
            TextFormField(
              controller: controller.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.mail,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Alamat
            TextFormField(
              controller: controller.address,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.location),
                labelText: TTexts.address,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Sekolah
            TextFormField(
              controller: controller.school,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your school';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.book),
                labelText: TTexts.school,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Nomor Telepon
            TextFormField(
              controller: controller.phoneNumber,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.call),
                labelText: TTexts.phonenumber,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Gender Dropdown
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.gender.value,
                onChanged: (String? newValue) {
                  controller.gender.value = newValue!;
                },
                items: <String>['Laki-Laki', 'Perempuan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Select your gender',
                  prefixIcon: Icon(Iconsax.personalcard),
                ),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Role Dropdown
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.role.value,
                onChanged: (String? newValue) {
                  controller.role.value = newValue!;
                },
                items: <String>['User', 'Admin']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  hintText: 'Select your role',
                  prefixIcon: Icon(Iconsax.shield),
                ),
              );
            }),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // Confirm Password
            TextFormField(
              controller: controller.confirmPassword,
              obscureText: controller.hidePassword.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != controller.password.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Tombol Sign Up
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Panggil registerUser untuk mengirim data registrasi hanya jika form valid
                  if (controller.registerFormKey.currentState!.validate()) {
                    controller.registerUser();  // Panggil registrasi
                  } else {
                    TLoaders.errorSnackBar(title: 'Invalid Input', message: 'Please fill in all required fields correctly.');
                  }
                },
                child: const Text(TTexts.signup),

                
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Register button
            TextButton(
              onPressed: () => Get.toNamed(TRoutes.login),
              child: const Text(TTexts.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
