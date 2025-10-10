import 'dart:convert';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/models/OutStock_models.dart';
import 'package:absensi/utils/popups/full_screen_loader.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OutstockController extends GetxController {
  final String baseUrl = 'http://192.168.100.160:1880/OCN/barang_keluar';
  final String getAllProductsUrl = 'http://192.168.100.160:1880/OCN/all_products/ambil';

   final RxList<OutStockProductModel> outStockProducts = <OutStockProductModel>[].obs;

  // Method to fetch out stock products
  Future<List<OutStockProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ambil'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          if (data['data'] is List) {
            final List<dynamic> productList = data['data'];
            return productList
                .map((json) => OutStockProductModel.fromJson(json))
                .toList();
          } else if (data['data'] is Map) {
            return [OutStockProductModel.fromJson(data['data'])];
          } else {
            throw Exception('Unexpected data format from API');
          }
        } else {
          throw Exception('Failed to load products: ${data['message']}');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchProducts: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Method to get all products for search
  Future<List<AllProductModel>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse(getAllProductsUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<AllProductModel> products = (data['data'] as List).map((productJson) {
            return AllProductModel.fromJson(productJson);
          }).toList();
          return products;
        } else {
          throw Exception('Gagal memuat produk: ${data['message']}');
        }
      } else {
        throw Exception('Gagal memuat produk: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat mengambil produk: $e');
    }
  }

  // Method to create an out stock product (barang keluar)
  Future<void> createProduct({
    required String productName,
    required double price,
    required int total,
    required String description,
    required BuildContext context,
  }) async {
    final Map<String, dynamic> productData = {
      'nama_barang': productName,
      'harga': price.toString(),
      'total': total.toString(),
      'deskripsi': description,
    };

    try {
      // TFullScreenLoader.openLoadingDialog('Menambah barang keluar...', context);
      
      final response = await http.post(
        Uri.parse('$baseUrl/tambah'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      TFullScreenLoader.stopLoading();

      // Handle response based on Node-RED flow
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          TLoaders.successSnackBar(
            title: 'Success',
            message: data['message'] ?? 'Barang keluar berhasil ditambahkan!',
          );
          Get.back();
        } else {
          TLoaders.errorSnackBar(
            title: 'Gagal Menambah Barang Keluar',
            message: data['message'] ?? 'Terjadi kesalahan.',
          );
        }
      } else if (response.statusCode == 400) {
        // Error from validation
        final data = json.decode(response.body);
        TLoaders.errorSnackBar(
          title: 'Gagal Menambah Barang Keluar',
          message: data['message'] ?? data['error'] ?? 'Data tidak valid.',
        );
      } else if (response.statusCode == 404) {
        // Product not found
        final data = json.decode(response.body);
        TLoaders.errorSnackBar(
          title: 'Gagal Menambah Barang Keluar',
          message: data['message'] ?? 'Produk tidak ditemukan.',
        );
      } else {
        // Other server errors
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server mengembalikan error dengan status code ${response.statusCode}.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Method to delete an out stock product
  Future<void> deleteProduct({
    required String id,
    required BuildContext context,
  }) async {
    try {
// TFullScreenLoader.openLoadingDialog('Menambah barang keluar...');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/hapus?id=$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      Navigator.pop(context);
      TFullScreenLoader.stopLoading();

      // Handle response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          TLoaders.successSnackBar(
            title: 'Success',
            message: data['message'] ?? 'Barang keluar berhasil dihapus!',
          );
        } else {
          TLoaders.errorSnackBar(
            title: 'Gagal Menghapus Barang Keluar',
            message: data['message'] ?? 'Terjadi kesalahan.',
          );
        }
      } else if (response.statusCode == 400) {
        // Error from validation
        final data = json.decode(response.body);
        TLoaders.errorSnackBar(
          title: 'Gagal Menghapus Barang Keluar',
          message: data['error'] ?? 'Data tidak valid.',
        );
      } else if (response.statusCode == 404) {
        // Data not found
        final data = json.decode(response.body);
        TLoaders.errorSnackBar(
          title: 'Gagal Menghapus Barang Keluar',
          message: data['error'] ?? 'Data tidak ditemukan.',
        );
      } else {
        // Other server errors
        Navigator.pop(context);
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server mengembalikan error dengan status code ${response.statusCode}.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Method to update an out stock product
  Future<void> updateProduct({
    required String id,
    required String productName,
    required int total,
    required String description,
    required BuildContext context,
  }) async {
    final Map<String, dynamic> productData = {
      'id': id,
      'nama_barang': productName,
      'total': total.toString(),
      'deskripsi': description,
    };

    try {
      // TFullScreenLoader.openLoadingDialog('Mengupdate barang keluar...', context);
      
      final response = await http.put(
        Uri.parse('$baseUrl/edit'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      TFullScreenLoader.stopLoading();

      // Handle response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          TLoaders.successSnackBar(
            title: 'Success',
            message: data['message'] ?? 'Barang keluar berhasil diupdate!',
          );
          Get.back();
        } else {
          TLoaders.errorSnackBar(
            title: 'Gagal Mengupdate Barang Keluar',
            message: data['message'] ?? 'Terjadi kesalahan.',
          );
        }
      } else if (response.statusCode == 400) {
        // Error from validation
        final data = json.decode(response.body);
        TLoaders.errorSnackBar(
          title: 'Gagal Mengupdate Barang Keluar',
          message: data['error'] ?? 'Data tidak valid.',
        );
      } else {
        // Other server errors
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server mengembalikan error dengan status code ${response.statusCode}.',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Error: ${e.toString()}',
      );
    }
  }

  // Method to get a single out stock product by ID
  Future<OutStockProductModel> getProductById(String id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/ambil?id=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        if (data['data'] is List && data['data'].isNotEmpty) {
          return OutStockProductModel.fromJson(data['data'][0]);
        } else if (data['data'] is Map) {
          return OutStockProductModel.fromJson(data['data']);
        } else {
          throw Exception('Unexpected data format from API');
        }
      } else {
        throw Exception('Failed to load product: ${data['message']}');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getProductById: $e');
    throw Exception('Error fetching product: $e');
  }
}
}