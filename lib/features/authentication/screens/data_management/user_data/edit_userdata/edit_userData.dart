import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';

import 'package:absensi/features/authentication/screens/data_management/user_data/edit_userdata/responsive_screens/edit_UserData_Desktop.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/edit_userdata/responsive_screens/edit_UserData_Mobile.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/edit_userdata/responsive_screens/edit_UserData_Tablet.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserDataScreen extends StatefulWidget {
  const EditUserDataScreen({super.key});

  @override
  State<EditUserDataScreen> createState() => _EditUserDataScreenState();
}

class _EditUserDataScreenState extends State<EditUserDataScreen> {
  UserModel? user;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _getUserFromArguments();
  }

  void _getUserFromArguments() async {
  try {
    final arguments = Get.arguments as Map<String, dynamic>?;
    
    // Cek dua kemungkinan: langsung UserModel atau hanya ID
    final userFromArgs = arguments?['user'] as UserModel?;
    final userId = arguments?['id'] as String?;
    
    if (userFromArgs != null) {
      setState(() {
        user = userFromArgs;
        isLoading = false;
      });
    } else if (userId != null && userId.isNotEmpty) {
      // Jika hanya dikirim ID, ambil data dari API
      final userService = Get.find<UserService>();
      final fetchedUser = await userService.getUserById(userId);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } else {
      throw Exception('Data user atau ID tidak ditemukan');
    }
  } catch (e) {
    print('Error getting user: $e');
    setState(() {
      error = e.toString();
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: _getUserFromArguments,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Data user tidak ditemukan')),
      );
    }

    return TSiteTemplate(
      desktop: EditUserDataDesktopScreen(user: user!),
      tablet: EditUserDataTabletScreen(user: user!),
      mobile: EditUserDataMobileScreen(user: user!),
    );
  }
}
