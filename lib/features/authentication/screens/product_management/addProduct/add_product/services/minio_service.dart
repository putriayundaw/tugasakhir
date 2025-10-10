import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class MinioService {
  final String minioBaseUrl = 'http://192.168.100.160:9000';
  final String minioBucket = 'ocn';

  Future<String?> uploadImageToMinIO({
    required Uint8List? imageBytes,
    required File? imageFile,
    required String imageName,
    required bool isWeb,
  }) async {
    try {
      if (imageBytes == null && imageFile == null) {
        print('ℹ️ No image selected for MinIO upload');
        return null;
      }

      print('📸 Starting MinIO image upload...');
      
      // // Generate unique filename
      // final timestamp = DateTime.now().millisecondsSinceEpoch;
      // final fileExtension = _getFileExtension(imageName);
      // final fileName = '${timestamp}_${_sanitizeFileName(imageName)}';
      
      // Upload URL
      final uploadUrl = '$minioBaseUrl/$minioBucket/produk/$imageName';
      // Full URL untuk di-return (imageUrl)
      final imageUrl = '$minioBaseUrl/$minioBucket/produk/$imageName';

      print('📤 Upload URL: $uploadUrl');
      print('🖼️ Image URL: $imageUrl');

      // Prepare image data
      List<int> bytes;
      String contentType;

      if (isWeb && imageBytes != null) {
        bytes = imageBytes;
        contentType = lookupMimeType('', headerBytes: bytes) ?? 'image/jpeg';
        print('🌐 Web upload: ${bytes.length} bytes');
      } else if (!kIsWeb && imageFile != null) {
        final file = imageFile;
        bytes = await file.readAsBytes();
        contentType = lookupMimeType(file.path) ?? 'image/jpeg';
        print('📱 Mobile upload: ${file.path}, ${bytes.length} bytes');
      } else {
        throw Exception('No image data available for upload');
      }

      // Upload ke MinIO
      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': contentType},
        body: bytes,
      ).timeout(const Duration(seconds: 30));

      print('📥 MinIO Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ SUCCESS: Image uploaded to MinIO');
        print('✅ Image URL: $imageUrl');
        return imageUrl; // Return full URL
      } else {
        throw Exception('MinIO upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ERROR in MinIO upload: $e');
      rethrow;
    }
  }

  String _getFileExtension(String fileName) {
    if (fileName.isEmpty) return 'jpg';
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : 'jpg';
  }

  String _sanitizeFileName(String fileName) {
    String name = fileName.split('').last.split('\\').last;
    name = name.replaceAll(RegExp(r'[^a-zA-Z0-9\.\-_]'), '_');
    return name;
  }

  Future<bool> testMinIOConnection() async {
    try {
      final testUrl = '$minioBaseUrl/minio/health/live';
      final response = await http.get(Uri.parse(testUrl)).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('❌ MinIO connection test failed: $e');
      return false;
    }
  }
}