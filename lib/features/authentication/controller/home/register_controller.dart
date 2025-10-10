import 'dart:convert';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/helpers/network_manager.dart';
import 'package:absensi/utils/popups/full_screen_loader.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // Observable untuk mengontrol visibilitas password
  final hidePassword = true.obs;

  // Controller untuk input email, password, dan lainnya
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final school = TextEditingController();
  final phoneNumber = TextEditingController();

  RxString gender = 'Laki-Laki'.obs;
  RxString role = 'User'.obs;

  // Key untuk validasi form register
  final registerFormKey = GlobalKey<FormState>();

  // Storage lokal untuk menyimpan data sederhana
  final localStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
  }

  // Fungsi untuk proses registrasi
  Future<void> registerUser() async {
    try {
      // Tampilkan loading saat proses registrasi berjalan
      TFullScreenLoader.openLoadingDialog('Registering your account...', TImages.docerAnimation);

      // Cek koneksi internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      // Kirim data registrasi ke API PHP untuk menyimpan ke MySQL
      final response = await _sendDataToServer();

      // Jika server mengembalikan status sukses
      if (response != null && response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          if (data['status'] == 'success') {
            // Menampilkan pesan sukses dan mengarahkan ke halaman login
            TFullScreenLoader.stopLoading();
            TLoaders.successSnackBar(title: 'Registration Successful', message: data['message']);
            Get.toNamed(TRoutes.login); // Arahkan ke halaman login
          } else {
            TFullScreenLoader.stopLoading();
            TLoaders.errorSnackBar(title: 'Registration Failed', message: data['message']);
          }
        } catch (e) {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(title: 'Error', message: 'Invalid server response: ${e.toString()}');
        }
      } else {
        // Jika API gagal mengirimkan data atau status bukan 200
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Registration Failed', message: 'Failed to connect to server.');
      }
    } catch (e) {
      // Jika ada error, hentikan loading dan tampilkan pesan error
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Registration Failed', message: e.toString());
    }
  }

  // Fungsi untuk mengirim data ke server PHP
  Future<http.Response?> _sendDataToServer() async {
    final url = Uri.parse('http://192.168.100.160:1880/OCN/register/tambah'); // Ganti dengan URL server kamu

    // Data yang akan dikirim ke server
    final data = {
      'name': name.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
      'address': address.text.trim(),
      'school': school.text.trim(),
      'phone_number': phoneNumber.text.trim(),
      'gender': gender.value,
      'role': role.value,
    };

    try {
      // Mengirim data ke server menggunakan metode POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response;
    } catch (e) {
      // Jika terjadi error
      print('Error: $e');
      return null;
    }
  }
}
