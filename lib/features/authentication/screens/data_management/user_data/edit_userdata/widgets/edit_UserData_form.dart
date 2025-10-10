
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({super.key, required this.user, this.onUserUpdated});

  final UserModel user;
  final VoidCallback? onUserUpdated;

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolController;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _gender;
  late String _role;
  late TextEditingController _inputDateController;

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: widget.user.school);
    _nameController = TextEditingController(text: widget.user.name);
    _addressController = TextEditingController(text: widget.user.address);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _emailController = TextEditingController(text: widget.user.email);
    _gender = widget.user.gender;
    _role = widget.user.role;
    _inputDateController = TextEditingController(
      text: widget.user.inputDate != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.user.inputDate!)
          : '',
    );
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _inputDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: TSizes.sm),
            Text(
              'Edit Data User',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Name Field
            TextFormField(
              controller: _nameController,
              validator: (value) => TValidator.validateEmptyText('Nama', value),
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Role Field
            DropdownButtonFormField<String>(
              value: _role.isNotEmpty ? _role : null,
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Iconsax.user),
              ),
              items: const [
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                DropdownMenuItem(value: 'User', child: Text('User')),
              ],
              onChanged: (value) {
                setState(() {
                  _role = value ?? '';
                });
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // School Field
            TextFormField(
              controller: _schoolController,
              validator: (value) =>
                  TValidator.validateEmptyText('School', value),
              decoration: const InputDecoration(
                labelText: 'School',
                prefixIcon: Icon(Iconsax.building),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Address Field
            TextFormField(
              controller: _addressController,
              validator: (value) =>
                  TValidator.validateEmptyText('Alamat', value),
              decoration: const InputDecoration(
                labelText: 'Alamat',
                prefixIcon: Icon(Iconsax.location),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: _gender.isNotEmpty ? _gender : null,
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                prefixIcon: Icon(Iconsax.user),
              ),
              items: const [
                DropdownMenuItem(value: 'Laki-Laki', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value ?? '';
                });
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              validator: (value) => TValidator.validatePhoneNumber(value),
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: Icon(Iconsax.call),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Email Field
            TextFormField(
              controller: _emailController,
              enabled: false,
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Iconsax.sms),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Input Date (Read-only)
            TextFormField(
              controller: _inputDateController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Tanggal Input',
                prefixIcon: Icon(Iconsax.calendar),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            // Update Button
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final updatedData = {
                        'name': _nameController.text,
                        'role': _role,
                        'school': _schoolController.text,
                        'address': _addressController.text,
                        'gender': _gender,
                        'phone_number': _phoneController.text,
                        'email': _emailController.text,
                      };

                      print(
                        'Sending update data: $updatedData',
                      ); // Debug data yang dikirim

                      final userService = Get.find<UserService>();
                      final success = await userService.updateUser(
                        widget.user.id,
                        updatedData,
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data user berhasil diperbarui!'),
                            backgroundColor: TColors.primary,
                          ),
                        );
                        widget.onUserUpdated?.call();
                        Get.back();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal memperbarui data user'),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Update Error: $e'); // Debug error detail
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: const Text('Perbarui'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
