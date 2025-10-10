import 'dart:convert';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/models/inStock_models.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/popups/full_screen_loader.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InstockController extends GetxController {
  // API URLs
  final String apiUrl = 'http://192.168.100.160:1880/OCN/barang_masuk/tambah';
  final String getAllProductsUrl = 'http://192.168.100.160:1880/OCN/all_products/ambil';
  final String fetchProductsUrl = 'http://192.168.100.160:1880/OCN/barang_masuk/ambil';
  final String deleteProductUrl = 'http://192.168.100.160:1880/OCN/barang_masuk/hapus';
  final String updateProductUrl = 'http://192.168.100.160:1880/OCN/barang_masuk/edit';

  // Rx variables for state management - HAPUS DUPLIKASI
  final RxBool isLoading = false.obs;
  final RxList<InStockProductModel> products = <InStockProductModel>[].obs;
  final RxList<AllProductModel> allProducts = <AllProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Auto load data saat controller diinisialisasi
  }

  // Method to fetch in-stock products - SATUKAN METHOD YANG DUPLIKAT
  Future<List<InStockProductModel>> fetchProducts() async {
    try {
      isLoading(true);
      print('🔄 Fetching in-stock products from: $fetchProductsUrl');
      
      final response = await http.get(
        Uri.parse(fetchProductsUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          List<InStockProductModel> productsList = [];
          
          if (data['data'] is List) {
            final List<dynamic> productList = data['data'];
            productsList = productList
                .map((json) => InStockProductModel.fromJson(json))
                .toList();
          } else if (data['data'] is Map) {
            productsList = [InStockProductModel.fromJson(data['data'])];
          } else {
            throw Exception('Unexpected data format from API');
          }
          
          products.assignAll(productsList);
          print('✅ Successfully loaded ${productsList.length} in-stock products');
          return productsList;
        } else {
          throw Exception('Failed to load products: ${data['message']}');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in fetchProducts: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load in-stock products: $e',
      );
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Method to get all products for search
  Future<List<AllProductModel>> getAllProducts() async {
    try {
      isLoading(true);
      print('🔄 Getting all products for search...');
      
      final response = await http.get(
        Uri.parse(getAllProductsUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          List<AllProductModel> productsList = (data['data'] as List)
              .map((productJson) => AllProductModel.fromJson(productJson))
              .toList();
          
          allProducts.assignAll(productsList);
          print('✅ Loaded ${productsList.length} products for search');
          return productsList;
        } else {
          throw Exception('Gagal memuat produk: ${data['message']}');
        }
      } else {
        throw Exception('Gagal memuat produk: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in getAllProducts: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data produk: $e',
      );
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Method to create a product (barang masuk)
  Future<void> createProduct({
    required String productName,
    required double price,
    required int total,
    required String description,
    
    required BuildContext context,
  }) async {
    try {

      
      final Map<String, dynamic> productData = {
        'nama_barang': productName,
        'harga': price.toString(),
        'total': total.toString(),
        'deskripsi': description,
        
      };

      print('📤 Sending data to API: $productData');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      );

      TFullScreenLoader.stopLoading();

      print('📥 Create response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          TLoaders.successSnackBar(
            title: 'Success!',
            message: data['message'] ?? 'Barang masuk berhasil ditambahkan!',
          );
          
          // Refresh data setelah berhasil create
          await fetchProducts();
          Get.offNamed(TRoutes.inStock);
        } else {
          TLoaders.errorSnackBar(
            title: 'Gagal',
            message: data['message'] ?? 'Terjadi kesalahan tidak diketahui.',
          );
        }
      } else {
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      print('❌ Error in createProduct: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal menambah barang masuk: ${e.toString()}',
      );
    }
  }

  // Method to delete a product (barang masuk)
  Future<void> deleteProduct({
    required String id,
    required BuildContext context,
  }) async {
    try {
     
      
      final response = await http.delete(
        Uri.parse('$deleteProductUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
      );

      TFullScreenLoader.stopLoading();

      print('📥 Delete response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          TLoaders.successSnackBar(
            title: 'Success!',
            message: data['message'] ?? 'Barang masuk berhasil dihapus!',
          );
          
          // Refresh data setelah berhasil delete
          await fetchProducts();
        } else {
          TLoaders.errorSnackBar(
            title: 'Gagal',
            message: data['message'] ?? 'Terjadi kesalahan tidak diketahui.',
          );
        }
      } else {
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      print('❌ Error in deleteProduct: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal menghapus barang masuk: ${e.toString()}',
      );
    }
  }

  // Method to update a product (barang masuk)
  Future<void> updateProduct({
    required String id,
    required String productName,
    required double price,
    required int total,
    required String description,
    required BuildContext context,
  }) async {
    try {
     
      
      final Map<String, dynamic> productData = {
        'id': id,
        'nama_barang': productName,
        'harga': price.toString(),
        'total': total.toString(),
        'deskripsi': description,
        
      };

      print('📤 Sending update data: $productData');

      final response = await http.put(
        Uri.parse(updateProductUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(productData),
      );

      TFullScreenLoader.stopLoading();

      print('📥 Update response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          TLoaders.successSnackBar(
            title: 'Success!',
            message: data['message'] ?? 'Barang masuk berhasil diupdate!',
          );
          
          // Refresh data setelah berhasil update
          await fetchProducts();
          Get.back();
        } else {
          TLoaders.errorSnackBar(
            title: 'Gagal',
            message: data['message'] ?? 'Terjadi kesalahan tidak diketahui.',
          );
        }
      } else {
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      print('❌ Error in updateProduct: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengupdate barang masuk: ${e.toString()}',
      );
    }
  }

  // Method to get a single product by ID
  Future<InStockProductModel> getProductById(String id) async {
    try {
      isLoading(true);
      print('🔄 Getting product by ID: $id');
      
      final response = await http.get(
        Uri.parse('$fetchProductsUrl?id=$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          if (data['data'] is List && data['data'].isNotEmpty) {
            return InStockProductModel.fromJson(data['data'][0]);
          } else if (data['data'] is Map) {
            return InStockProductModel.fromJson(data['data']);
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
      print('❌ Error in getProductById: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data produk: $e',
      );
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Refresh data manually
  Future<void> refreshData() async {
    await fetchProducts();
  }
}