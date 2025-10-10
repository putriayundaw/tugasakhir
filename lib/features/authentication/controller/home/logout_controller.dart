import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogoutController extends GetxController {
  var isLoggingOut = false.obs;
  var errorMessage = ''.obs;

  Future<void> logout() async {
    isLoggingOut.value = true;
    errorMessage.value = '';

    try {
      print('Mengirim request logout ke server...');
      final response = await http.post(
        Uri.parse('http://192.168.100.160:1880/OCN/logout/tambah'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({}),
      );
      
      print('Response diterima dari server dengan status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          Get.snackbar('Logout', 'Logout berhasil');
          
         
          // Navigate ke login page
          Get.offAllNamed('/login');
        } else {
          errorMessage.value = 'Logout gagal: ${responseBody['message']}';
          Get.snackbar('Logout Error', errorMessage.value);
        }
      } else {
        errorMessage.value = 'Gagal terhubung ke server, status code: ${response.statusCode}';
        Get.snackbar('Logout Error', errorMessage.value);
      }
    } on http.ClientException catch (e) {
      errorMessage.value = 'ClientException: ${e.message}';
      Get.snackbar('Logout Error', errorMessage.value);
    } on Exception catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      Get.snackbar('Logout Error', errorMessage.value);
    } finally {
      isLoggingOut.value = false;
    }
  }
}