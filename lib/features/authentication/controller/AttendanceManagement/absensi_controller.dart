import 'dart:convert';
import 'package:absensi/features/authentication/screens/data_management/absensi/models/absensi_model.dart';
import 'package:http/http.dart' as http;

class Attendancecontroller {
  static const String baseUrl = 'http://192.168.100.160:1880';
  static const String username = 'raspberry';
  static const String password = 'cerdas2023';

  static Map<String,String> _defaultHeaders() {
    final creds = base64Encode(utf8.encode('$username:$password'));
    return {
      'Accept': 'application/json',
    };
  }

  static Future<List<Attendance>> getAttendanceData() async {
    final url = Uri.parse('$baseUrl/fingerprint/attendance');
    try {
      final response = await http.get(url, headers: _defaultHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((j) => Attendance.fromJson(j)).toList();
      } else {
        throw Exception('Failed to load attendance data: ${response.statusCode} -- body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  static Future<List<Attendance>> searchAttendance(String query) async {
    final url = Uri.parse('$baseUrl/fingerprint/attendance/search?q=${Uri.encodeQueryComponent(query)}');
    try {
      final response = await http.get(url, headers: _defaultHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((j) => Attendance.fromJson(j)).toList();
      } else {
        throw Exception('Failed to search attendance data: ${response.statusCode} -- body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error searching data: $e');
    }
  }
}
