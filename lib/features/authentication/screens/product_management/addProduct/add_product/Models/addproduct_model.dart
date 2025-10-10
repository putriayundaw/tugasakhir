import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk debugPrint

class ProductModel {
  final String id;
  final String name;
  final String price;
  final String total;
  final String? parentProduct;
  final String imageUrl;
  final DateTime? dateAdded;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.total,
    this.parentProduct,
    required this.imageUrl,
    this.dateAdded,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // DEBUG: Print raw JSON untuk troubleshooting
    debugPrint('🔍 Raw Product JSON: $json');

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['nama_barang']?.toString() ?? '',
      price: json['harga']?.toString() ?? '0',
      total: json['total']?.toString() ?? '0',
      parentProduct: json['parent_addproduct']?.toString(),
      imageUrl: _parseImageUrl(json['image']?.toString() ?? ''),
      // PERBAIKAN: Coba multiple field untuk tanggal
      dateAdded: _parseDateTime(
        json['created_at'] ?? 
        json['date_added'] ??
        json['tanggal'] ??
        json['date']
      ),
    );
  }

  // Method untuk parsing tanggal dari berbagai format
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return null;
    }

    final String dateString = dateValue.toString();
    debugPrint('📅 Parsing date: "$dateString"');

    // Coba parse sebagai DateTime langsung
    DateTime? parsedDate = DateTime.tryParse(dateString);
    if (parsedDate != null) {
      return parsedDate;
    }

    // Coba format dari MySQL timestamp (YYYY-MM-DD HH:MM:SS)
    if (dateString.contains(' ') && dateString.contains('-')) {
      try {
        final parts = dateString.split(' ');
        if (parts.length == 2) {
          final datePart = parts[0];
          final timePart = parts[1];
          parsedDate = DateTime.tryParse('${datePart}T$timePart');
          if (parsedDate != null) {
            return parsedDate;
          }
        }
      } catch (e) {
        debugPrint('❌ Error parsing MySQL timestamp: $e');
      }
    }

    // Coba format Indonesia (DD-MM-YYYY)
    if (dateString.contains('-') && dateString.length == 10) {
      try {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          
          if (day != null && month != null && year != null) {
            // Jika day > 12, kemungkinan format DD-MM-YYYY
            if (day > 12 && day <= 31 && month <= 12) {
              return DateTime(year, month, day);
            }
            // Jika month > 12, kemungkinan format MM-DD-YYYY
            else if (month > 12 && month <= 31 && day <= 12) {
              return DateTime(year, day, month);
            }
          }
        }
      } catch (e) {
        debugPrint('❌ Error parsing custom format: $e');
      }
    }

    debugPrint('❌ Could not parse date: $dateString');
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': name,
      'harga': price,
      'total': total,
      if (parentProduct != null) 'parent_addproduct': parentProduct,
      'image': imageUrl,
      if (dateAdded != null) 'created_at': dateAdded!.toIso8601String(),
    };
  }

  // Fungsi untuk mem-parse URL gambar
  static String _parseImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      debugPrint('❌ Empty image path');
      return '';
    }
    
    debugPrint('🔍 Processing image path: "$imagePath"');
    
    const baseUrl = 'http://192.168.100.160:9000';
    
    if (imagePath.trim().endsWith('/')) {
      debugPrint('❌ REJECTED: Path is directory (ends with slash)');
      return '';
    }
    
    final validExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp'];
    bool hasValidExtension = validExtensions.any((ext) => 
        imagePath.toLowerCase().contains(ext));
    
    if (!hasValidExtension) {
      debugPrint('❌ REJECTED: No valid image extension found');
      return '';
    }
    
    String finalUrl = imagePath;
    
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      finalUrl = imagePath.replaceAll('900l', '9000');
    }
    else if (imagePath.contains('http://')) {
      final startIndex = imagePath.indexOf('http://');
      finalUrl = imagePath.substring(startIndex);
      finalUrl = finalUrl.replaceAll('900l', '9000');
      
      final endPatterns = [' ', ')', ']', '}'];
      for (var pattern in endPatterns) {
        if (finalUrl.contains(pattern)) {
          finalUrl = finalUrl.substring(0, finalUrl.indexOf(pattern));
        }
      }
    }
    else {
      if (imagePath.startsWith('/')) {
        finalUrl = baseUrl + imagePath;
      } else {
        finalUrl = '$baseUrl/$imagePath';
      }
    }
    
    if (finalUrl.endsWith('/') || !finalUrl.contains('.')) {
      debugPrint('❌ REJECTED: Final URL still invalid: $finalUrl');
      return '';
    }
    
    debugPrint('✅ ACCEPTED: $finalUrl');
    return finalUrl;
  }

  static List<String> _parseImages(dynamic raw) {
    if (raw == null) return [];
    if (raw is String) {
      try {
        final decoded = raw.startsWith('[') ? jsonDecode(raw) : null;
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
      } catch (_) {}
      return [raw];
    }
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return [];
  }
}