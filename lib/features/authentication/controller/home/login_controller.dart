import 'dart:convert';
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi/utils/popups/exports.dart';
import 'package:absensi/utils/helpers/network_manager.dart';
import 'package:absensi/utils/constans/image_strings.dart';

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

  // Observable untuk data user yang akan digunakan di header
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userRole = ''.obs;
  final RxString userId = ''.obs;

  @override
  void onInit() {
    // Saat controller diinisialisasi, ambil data yang disimpan di localStorage jika ada
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    
    // Load user data dari storage
    _loadUserDataFromStorage();
    super.onInit();
  }

  // Fungsi untuk load data user dari localStorage
  void _loadUserDataFromStorage() {
    print('🔄 Loading user data from storage...');
    
    // Pastikan kita selalu mengambil data terbaru dari localStorage
    final storedName = localStorage.read('userName');
    final storedEmail = localStorage.read('userEmail');
    final storedRole = localStorage.read('userRole');
    final storedId = localStorage.read('userId');
    
    if (storedName != null) userName.value = storedName;
    if (storedEmail != null) userEmail.value = storedEmail;
    if (storedRole != null) userRole.value = storedRole;
    if (storedId != null) userId.value = storedId;
    
    print('📦 Loaded user data: $storedName, $storedEmail');
  }

  // Fungsi untuk menyimpan data user ke localStorage
  void _saveUserDataToStorage() {
    print('💾 Saving user data to storage...');
    
    localStorage.write('userName', userName.value);
    localStorage.write('userEmail', userEmail.value);
    localStorage.write('userRole', userRole.value);
    localStorage.write('userId', userId.value);
    localStorage.write('isLoggedIn', true);
    
    print('✅ User data saved to storage');
  }

  // ✅ METHOD _loginUser YANG DIPERBAIKI
  Future<http.Response?> _loginUser() async {
    final url = Uri.parse('http://192.168.100.160:1880/OCN/login/tambah');

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

  // ✅ METHOD _logoutUser YANG DIPERBAIKI
  Future<http.Response?> _logoutUser() async {
    final url = Uri.parse('http://192.168.100.160:1880/OCN/logout/tambah');
    
    final data = {};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response;
    } catch (e) {
      print('Error calling logout API: $e');
      return null;
    }
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

          // Periksa status login berdasarkan Node-RED response format
          if (data['status'] == 'success') {
            // Ambil data user dari response (sesuai format Node-RED)
            final userData = data['user'];
            final userRole = userData['role'];
            final userEmail = userData['email'];
            final userId = userData['id'].toString();
            
            TFullScreenLoader.stopLoading();

            // Cek jika role ada dan cocok
            if (userRole != null) {
              // Update data user di controller
              String username;
              try {
                // Coba ambil data lengkap user dari server
                final userService = Get.find<UserService>();
                final fullUser = await userService.getUserById(userId);
                username = fullUser.name.isNotEmpty ? fullUser.name : fullUser.email.split('@')[0];
              } catch (e) {
                // Jika gagal ambil data lengkap, gunakan data dasar dari login
                username = userData['name'] ?? userEmail.split('@')[0];
              }

              // SIMPAN DATA KE OBSERVABLE VARIABLES
              this.userName.value = username;
              this.userEmail.value = userEmail;
              this.userRole.value = userRole;
              this.userId.value = userId;

              // Simpan data pengguna ke local storage
              _saveUserDataToStorage();

              // Simpan data pengguna jika "Ingat Saya" dipilih
              if (rememberMe.value) {
                localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
                localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
              } else {
                // Hapus data jika "Ingat Saya" tidak dipilih
                localStorage.remove('REMEMBER_ME_EMAIL');
                localStorage.remove('REMEMBER_ME_PASSWORD');
              }

              // Redirect berdasarkan role
              Get.offAllNamed(TRoutes.dashboard);
              
              TLoaders.successSnackBar(title: 'Login Success', message: 'Welcome back!');
            } else {
              TLoaders.errorSnackBar(title: 'Invalid Role', message: 'User role not found.');
            }
          } else {
            TFullScreenLoader.stopLoading();
            TLoaders.errorSnackBar(
              title: 'Login Failed', 
              message: data['message'] ?? 'Invalid email or password.'
            );
          }
        } else {
          TFullScreenLoader.stopLoading();
          TLoaders.errorSnackBar(
            title: 'Server Error', 
            message: 'Server returned an error with status code ${response.statusCode}.'
          );
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

  // Fungsi untuk logout
  Future<void> logout() async {
    try {
      TFullScreenLoader.openLoadingDialog('Logging out..', TImages.docerAnimation);
      
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        Get.snackbar(
          'No Internet',
          'Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }

      // Panggil API logout di Node-RED
      final response = await _logoutUser();
      
      // Selalu lakukan logout lokal terlepas dari response server
      _performLocalLogout();
      
      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          Get.snackbar(
            'Logout Success',
            data['message'] ?? 'You have been logged out.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: TColors.primary,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            'Logout Warning', 
            data['message'] ?? 'Logged out locally but server sync failed.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Logout Warning', 
          'Logged out locally but server connection failed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      _performLocalLogout();
      Get.snackbar(
        'Logout Warning', 
        'Logged out locally but encountered an error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Fungsi untuk logout lokal
  void _performLocalLogout() {
    // Clear data user dari observable variables
    userName.value = '';
    userEmail.value = '';
    userRole.value = '';
    userId.value = '';
    
    // Hapus data dari local storage
    localStorage.remove('isLoggedIn');
    localStorage.remove('userEmail');
    localStorage.remove('userRole');
    localStorage.remove('userId');
    localStorage.remove('userName');
    localStorage.remove('REMEMBER_ME_EMAIL');
    localStorage.remove('REMEMBER_ME_PASSWORD');
    
    TFullScreenLoader.stopLoading();
    
    // Redirect ke halaman login
    Get.offAllNamed(TRoutes.login);
  }

  // ✅ FUNGSI UTAMA UNTUK HEADER

  // Fungsi untuk memeriksa status login
  bool isLoggedIn() {
    return localStorage.read('isLoggedIn') ?? false;
  }

  // Fungsi untuk mendapatkan role user
  String getUserRole() {
    // Prioritaskan data dari observable, fallback ke localStorage
    if (userRole.value.isNotEmpty) return userRole.value;
    return localStorage.read('userRole') ?? '';
  }

  // Fungsi untuk mendapatkan email user
  String getUserEmail() {
    // Prioritaskan data dari observable, fallback ke localStorage
    if (userEmail.value.isNotEmpty) return userEmail.value;
    return localStorage.read('userEmail') ?? '';
  }

  // Fungsi untuk mendapatkan user ID
  String getUserId() {
    // Prioritaskan data dari observable, fallback ke localStorage
    if (userId.value.isNotEmpty) return userId.value;
    return localStorage.read('userId') ?? '';
  }

  // Fungsi untuk mendapatkan username
  String getUserName() {
    // 1. Prioritaskan data dari observable variable
    if (userName.value.isNotEmpty) {
      return userName.value;
    }
    
    // 2. Coba ambil dari localStorage
    final storedName = localStorage.read('userName');
    if (storedName != null && storedName.isNotEmpty) {
      // Update observable variable untuk konsistensi
      userName.value = storedName;
      return storedName;
    }
    
    // 3. Fallback: generate dari email
    final email = getUserEmail();
    if (email.isNotEmpty) {
      final generatedName = email.split('@')[0];
      // Simpan ke observable untuk penggunaan berikutnya
      userName.value = generatedName;
      return generatedName;
    }
    
    // 4. Final fallback
    return 'User';
  }

  // Fungsi untuk refresh data user dari storage
  void refreshUserData() {
    _loadUserDataFromStorage();
    update(); // Paksa update semua observer
  }

  // Fungsi untuk memastikan data tersedia (panggil di initState halaman)
  void ensureUserData() {
    if (userName.value.isEmpty || userEmail.value.isEmpty) {
      _loadUserDataFromStorage();
    }
  }

  // ✅ METHOD UNTUK PENGE CEKAN SESSION DENGAN SERVER
  Future<bool> checkServerSession() async {
    try {
      final response = await _logoutUser(); // Reuse logout endpoint untuk cek session
      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] != 'error';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Fungsi untuk update user profile (jika diperlukan)
  void updateUserProfile(String name, String email) {
    userName.value = name;
    userEmail.value = email;
    _saveUserDataToStorage();
    update(); // Notify listeners
  }
}