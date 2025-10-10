import 'dart:convert';

import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/Models/userData_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserService extends GetxService {
  static const String baseUrl = 'http://192.168.100.160:1880';

  final RxList<UserModel> _users = <UserModel>[].obs;
  List<UserModel> get users => _users;

  // Add reactive getter for users
  RxList<UserModel> get reactiveUsers => _users;

  Future<void> fetchUsers() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/OCN/register/ambil'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'] ?? [];
      _users.assignAll(
        dataList.map((json) => UserModel.fromJson(json)).toList(),
      );

      for (var user in _users) {
        print('User: ${user.name}, ID: ${user.id}');
      }
    } else {
      throw Exception('Gagal mengambil data users: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error mengambil users: $e');
  }
}

  Future<UserModel> getUserById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/OCN/register/ambil?uid=$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'] ?? [];
      if (dataList.isNotEmpty) {
        return UserModel.fromJson(dataList[0]);
      } else {
        throw Exception('User tidak ditemukan');
      }
    } else {
      throw Exception('Gagal memuat data user: ${response.statusCode}');
    }
  }

  Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/OCN/register/edit?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Update Response: $jsonData'); // Debug response

        if (jsonData['status'] == 'success') {
          // Update local list
          final index = _users.indexWhere((user) => user.id == id);
          if (index != -1) {
            final updatedUser = UserModel(
              id: id,
              name: data['name'],
              role: data['role'],
              school: data['school'],
              address: data['address'],
              gender: data['gender'],
              phoneNumber: data['phone_number'],
              email: data['email'],
              inputDate: _users[index].inputDate, // Pertahankan tanggal lama
            );
            _users[index] = updatedUser;
            _users.refresh();
          }
          return true;
        } else {
          throw Exception(jsonData['message'] ?? 'Gagal memperbarui data');
        }
      } else {
        throw Exception(
          'HTTP Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update User Error: $e'); // Debug error
      throw Exception('Error update user: $e');
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      print('Deleting user with UID: $id'); // Debug

      final response = await http.delete(
        Uri.parse('$baseUrl/OCN/register/hapus?id=$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Delete Response: $jsonData'); // Debug

        if (jsonData['status'] == 'success') {
          // Remove from local list
          _users.removeWhere((user) => user.id == id);
          _users.refresh();
          return true;
        } else {
          throw Exception(jsonData['message'] ?? 'Gagal menghapus user');
        }
      } else {
        throw Exception(
          'HTTP Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Delete User Error: $e'); // Debug
      throw Exception('Error hapus user: $e');
    }
  }
}
