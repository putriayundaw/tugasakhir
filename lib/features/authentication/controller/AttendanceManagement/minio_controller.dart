import 'dart:typed_data';
import 'package:http/http.dart' as http;

class MinioService {
  static final MinioService _instance = MinioService._internal();
  factory MinioService() => _instance;
  MinioService._internal();

  final String _endpoint = '192.168.100.160';
  final int _port = 9000;
  final bool _useSSL = false;
  final String _accessKey = 'minioadmin';
  final String _secretKey = 'minioadmin';
  final String _bucketName = 'ocn';

  Future<void> initialize() async {
    try {
      final response = await http.get(
        Uri.parse('${_useSSL ? 'https' : 'http'}://$_endpoint:$_port/minio/health/live'),
      );

      if (response.statusCode == 200) {
        print('MinIO service initialized successfully');
      } else {
        throw Exception('MinIO server not responding');
      }
    } catch (e) {
      print('Error initializing MinIO: $e');
      print('MinIO service initialized (assuming server is running)');
    }
  }

  Future<String> uploadFromBytes(Uint8List bytes, String fileName, {String? folderName}) async {
    try {
      final String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_sanitizeFileName(fileName)}';

      final objectKey = (folderName == null || folderName.trim().isEmpty)
          ? uniqueFileName
          : '${folderName.trim()}/$uniqueFileName';

      final String uploadUrl =
          '${_useSSL ? 'https' : 'http'}://$_endpoint:$_port/$_bucketName/$objectKey';

      final response = await http.put(
        Uri.parse(uploadUrl),
        body: bytes,
        headers: {
          'Content-Type': _getContentType(fileName),
        },
      );

      if (response.statusCode == 200) {
        print('File uploaded successfully: $objectKey');
        return _getPublicUrl(objectKey);
      } else {
        throw Exception('Upload failed with status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error uploading file to MinIO: $e');
      throw Exception('Failed to upload file: $e');
    }
  }

  String _getPublicUrl(String objectKey) {
    return '${_useSSL ? 'https' : 'http'}://$_endpoint:$_port/$_bucketName/$objectKey';
  }

  String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^a-zA-Z0-9\.\-_]'), '_');
  }

  Future<List<String>> uploadMultipleFiles(List<Uint8List> filesBytes, List<String> fileNames, {String? folderName}) async {
    final List<String> urls = [];

    for (int i = 0; i < filesBytes.length; i++) {
      try {
        final url = await uploadFromBytes(filesBytes[i], fileNames[i], folderName: 'foto_izin');
        urls.add(url);

        await _testUrlAccessibility(url);
      } catch (e) {
        print('Error uploading file ${fileNames[i]}: $e');
        continue;
      }
    }

    return urls;
  }

  Future<void> _testUrlAccessibility(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      print('URL Access Test: $url → Status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        print('WARNING: URL might not be accessible: $url');
      }
    } catch (e) {
      print('URL Access Test Failed: $url → Error: $e');
    }
  }

  String _getContentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  String getFileUrl(String fileName, {String? folderName}) {
    final objectKey = (folderName == null || folderName.trim().isEmpty)
        ? fileName
        : '${folderName.trim()}/$fileName';
    return _getPublicUrl(objectKey);
  }
}
