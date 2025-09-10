import 'package:absensi/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:absensi/utils/popups/exports.dart';
import 'package:absensi/utils/helpers/network_manager.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/text_strings.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Observable untuk mengontrol visibilitas password
  final hidePassword = true.obs;

  // Observable untuk opsi "Ingat saya"
  final rememberMe = false.obs;

  // Controller untuk input email dan password
  final email = TextEditingController();
  final password = TextEditingController();

  // Key untuk validasi form login
  final loginFormkey = GlobalKey<FormState>();

  final localStorage = GetStorage();

  @override
  void onInit() {
    // Saat controller diinisialisasi, ambil email dan password yang disimpan di localStorage jika ada
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  // Fungsi untuk login menggunakan email dan password
  Future<void> emailAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog('Logging you in..', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      // Validasi input email dan password
      if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Invalid Input', message: 'Email and password cannot be empty.');
        return;
      }

      // Kirimkan data login ke server untuk memverifikasi kredensial
      final response = await _loginUser();

      if (response != null) {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // Periksa status login
          if (data['status'] == 'success') {
            // Ambil role dari data
            final userRole = data['data']['role'];  // Mendapatkan role pengguna
            TFullScreenLoader.stopLoading();

            // Cek jika role ada dan cocok
            if (userRole != null) {
              if (userRole.toLowerCase() == 'admin') {
                Get.toNamed(TRoutes.dashboard);  // Ganti dengan route dashboard admin
              } else if (userRole.toLowerCase() == 'user') {
                Get.toNamed(TRoutes.dashboard);  // Ganti dengan route home untuk user
              } else {
                TLoaders.errorSnackBar(title: 'Invalid Role', message: 'Invalid user role');
              }

              // Simpan email dan password jika "Ingat Saya" dipilih
              if (rememberMe.value) {
                localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
                localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
              }
            } else {
              TLoaders.errorSnackBar(title: 'Invalid Role', message: 'Role not found.');
            }
          } else {
            TFullScreenLoader.stopLoading();
            TLoaders.errorSnackBar(title: 'Login Failed', message: data['message'] ?? 'Invalid email or password.');
          }
        } else {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(title: 'Server Error', message: 'Server returned an error with status code ${response.statusCode}.');
        }
      } else {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Login Failed', message: 'No response from server.');
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Login Failed', message: 'Error: ${e.toString()}');
    }
  }

  // Fungsi untuk mengirim data login ke server
  Future<http.Response?> _loginUser() async {
    final url = Uri.parse('http://192.168.100.160:1880/OCN/login'); // Ganti dengan URL server kamu

    final data = {
      'email': email.text.trim(),
      'password': password.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
