// all_product_model.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AllProductModel {
  final String id;
  final String name;
 final double price; 
  final int stock;
    final DateTime? createdAt; 
  final String borrowed;
  final String returned;
  final String imageUrl;

  AllProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
      this.createdAt,
    required this.borrowed,
    required this.returned,
    required this.imageUrl,
  });

  factory AllProductModel.fromJson(Map<String, dynamic> json) {
    // DEBUG: Print raw JSON untuk troubleshooting
    debugPrint('🔍 Raw AllProduct JSON: $json');

    return AllProductModel(
      id: json['id']?.toString() ?? '',
      name: json['nama_barang']?.toString() ?? '',
      price: double.tryParse(json['harga']?.toString() ?? '0') ?? 0.0,
      stock: (json['stock'] as int?) ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(), // Default ke s
      borrowed: json['dipinjam']?.toString() ?? '0',
      returned: json['dikembalikan']?.toString() ?? '0',
      // GUNAKAN LOGICA PARSING YANG SAMA DENGAN ProductModel
      imageUrl: _parseImageUrl(json['image']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': name,
      'harga': price,
      'stock': stock,
      'dipinjam': borrowed,
      'dikembalikan': returned,
      'image_url': imageUrl,
    };
  }

  // FUNGSI _parseImageUrl YANG SAMA DENGAN ProductModel
  static String _parseImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      debugPrint('❌ Empty image path');
      return '';
    }
    
    debugPrint('🔍 Processing image path: "$imagePath"');
    
    const baseUrl = 'http://192.168.100.160:9000';
    
    String finalUrl = imagePath;
    
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      finalUrl = imagePath.replaceAll('900l', '9000');
    } else if (imagePath.contains('http://')) {
      final startIndex = imagePath.indexOf('http://');
      finalUrl = imagePath.substring(startIndex);
      finalUrl = finalUrl.replaceAll('900l', '9000');
      
      final endPatterns = [' ', ')', ']', '}'];
      for (var pattern in endPatterns) {
        if (finalUrl.contains(pattern)) {
          finalUrl = finalUrl.substring(0, finalUrl.indexOf(pattern));
        }
      }
    } else {
      if (imagePath.startsWith('/')) {
        finalUrl = baseUrl + imagePath;
      } else {
        finalUrl = '$baseUrl/ocn/produk/$imagePath';
      }
    }
    
    debugPrint('✅ ACCEPTED: $finalUrl');
    return finalUrl;
  }

  // Tetap pertahankan method _parseImages jika diperlukan di tempat lain
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