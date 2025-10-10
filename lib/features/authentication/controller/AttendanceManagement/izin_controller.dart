import 'dart:convert';
import 'package:absensi/features/authentication/screens/data_management/izin/Models/permission_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class IzinController extends GetxController {
  final RxList<PermissionModel> permissions = <PermissionModel>[].obs;
  final RxList<PermissionModel> filteredPermissions = <PermissionModel>[].obs;
  final RxString searchQuery = ''.obs;
  final String baseUrl = 'http://192.168.100.160:1880';

  Future<void> fetchPermissions() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/permission/list')).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        permissions.assignAll(data.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>)).toList());
        _filterPermissions();
      } else {
        print('fetchPermissions HTTP ${res.statusCode}: ${res.body}');
        permissions.clear();
        filteredPermissions.clear();
      }
    } catch (e) {
      print('fetchPermissions error: $e');
      permissions.clear();
      filteredPermissions.clear();
    }
  }

  void searchPermissions(String query) {
    searchQuery.value = query.trim();
    _filterPermissions();
  }

  void _filterPermissions() {
    if (searchQuery.value.isEmpty) {
      filteredPermissions.assignAll(permissions);
    } else {
      filteredPermissions.assignAll(
        permissions.where((permission) =>
          permission.name.toLowerCase().contains(searchQuery.value.toLowerCase())
        ).toList()
      );
    }
  }

  Future<bool> createPermission({
    required String name,
    required String school,
    required String day,
    required String date,
    required String information,
    required List<String> images,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/permission/create');

      List<String> imageFilenames = images.map((url) {
        try {
          final uri = Uri.parse(url);
          return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : url;
        } catch (_) {
          return url;
        }
      }).toList();

      final body = jsonEncode({
        'name': name,
        'school': school,
        'day': day,
        'date': date,
        'information': information,
        'images': imageFilenames,
      });

      final res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200 || res.statusCode == 201) return true;
      print('createPermission failed ${res.statusCode} -> ${res.body}');
      return false;
    } catch (e) {
      print('createPermission exception: ${e.toString()}');
      return false;
    }
  }
}

