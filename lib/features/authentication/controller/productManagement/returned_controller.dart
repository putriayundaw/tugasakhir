import 'dart:convert';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/models/returned_models.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/popups/full_screen_loader.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReturnedProductController extends GetxController {
  static const String baseUrl = 'http://192.168.100.160:1880';
  final String fetchProductsUrl = '$baseUrl/OCN/pengembalian_barang/ambil';

  final RxList<ReturnedProductModels> allProducts = <ReturnedProductModels>[].obs;
  final RxList<ReturnedProductModels> filteredProducts = <ReturnedProductModels>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    debounce(searchQuery, (_) => filterProducts(), 
      time: const Duration(milliseconds: 300));
    loadProducts();
  }

  // Load all products
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final products = await fetchReturnedProducts();
      allProducts.assignAll(products);
      filteredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load returned products: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Filter products based on search query
  void filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredProducts.assignAll(
        allProducts.where((product) =>
          product.namaBarang.toLowerCase().contains(query) ||
          product.namaPeminjam.toLowerCase().contains(query) ||
          product.total.toString().contains(query)
        ).toList()
      );
    }
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    filteredProducts.assignAll(allProducts);
  }

  // Method to fetch returned products
  Future<List<ReturnedProductModels>> fetchReturnedProducts() async {
    try {
      final response = await http.get(Uri.parse(fetchProductsUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          if (data['data'] is List) {
            final List<dynamic> productList = data['data'];
            return productList
                .map((json) => ReturnedProductModels.fromJson(json))
                .toList();
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
      print('Error in fetchReturnedProducts: $e');
      throw Exception('Error fetching returned products: $e');
    }
  }

  // GET - Ambil data produk untuk dropdown (digunakan untuk form tambah pengembalian)
  static Future<List<AllProductModel>> fetchProducts() async {
    try {
      print('Fetching products from: $baseUrl/OCN/all_products/ambil');
      
      final response = await http.get(
        Uri.parse('$baseUrl/OCN/all_products/ambil'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        List<dynamic> productsList = [];
        
        if (responseData is List) {
          productsList = responseData;
        } else if (responseData is Map && responseData['data'] is List) {
          productsList = responseData['data'];
        } else if (responseData is Map && responseData['status'] == 'success' && responseData['data'] is List) {
          productsList = responseData['data'];
        } else {
          throw Exception('Invalid response format: ${response.body}');
        }

        List<AllProductModel> products = productsList.map((product) {
          if (product is Map<String, dynamic>) {
            return AllProductModel.fromJson(product);
          } else {
            throw Exception('Invalid product data format: $product');
          }
        }).toList();

        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // POST - Tambah data pengembalian
  static Future<Map<String, dynamic>> addReturnedProduct(ReturnedProductModels product) async {
    try {
      final payload = product.toJson();
      print('Sending payload: $payload');

      final response = await http.post(
        Uri.parse('$baseUrl/OCN/pengembalian_barang/tambah'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      print('Add returned response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Menampilkan loader dan snack bar setelah berhasil
        TFullScreenLoader.stopLoading();
        TLoaders.successSnackBar(title: 'Pengembalian berhasil ditambahkan', message: responseData['message'] ?? 'Berhasil');

        // Navigasi menggunakan GetX
        Get.toNamed(TRoutes.returnedProduct); // Arahkan ke halaman yang sesuai

        return {
          'success': true,
          'message': responseData['message'] ?? 'Pengembalian berhasil ditambahkan',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(message: 'Error: $e', title: null);
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // GET semua data pengembalian
  static Future<List<ReturnedProductModels>> getReturnedProducts({int? id}) async {
    try {
      String endpoint = '/OCN/pengembalian_barang/ambil';
      if (id != null) {
        endpoint += '?id=$id';
      }

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData is Map && responseData['status'] == 'success') {
          if (responseData['data'] is List) {
            return (responseData['data'] as List).map((item) => ReturnedProductModels.fromJson(item)).toList();
          } else {
            throw Exception('Data format is not list');
          }
        } else {
          // Jika response tidak memiliki struktur yang diharapkan, coba langsung parse sebagai list
          if (responseData is List) {
            return responseData.map((item) => ReturnedProductModels.fromJson(item)).toList();
          } else {
            throw Exception('Invalid response structure: ${response.body}');
          }
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT - Edit data pengembalian
  static Future<Map<String, dynamic>> updateReturnedProduct(ReturnedProductModels product) async {
    try {
      final payload = product.toJson();
      print('Sending update payload: $payload');

      final response = await http.put(
        Uri.parse('$baseUrl/OCN/pengembalian_barang/edit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      print('Update returned response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        TLoaders.successSnackBar(title: 'Berhasil', message: responseData['message'] ?? 'Pengembalian berhasil diperbarui');

        return {
          'success': true,
          'message': responseData['message'] ?? 'Pengembalian berhasil diperbarui',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Gagal memperbarui pengembalian: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // DELETE - Hapus data pengembalian
  static Future<Map<String, dynamic>> deleteReturnedProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/OCN/pengembalian_barang/hapus?id=$id'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Delete returned response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        TLoaders.successSnackBar(title: 'Berhasil', message: responseData['message'] ?? 'Pengembalian berhasil dihapus');

        return {
          'success': true,
          'message': responseData['message'] ?? 'Pengembalian berhasil dihapus',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Gagal menghapus pengembalian: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Validasi data
  static Map<String, String>? validateReturnedProduct(
    String namaBarang,
    String namaPeminjam,
    int total,
    DateTime tanggal, {
    String? deskripsi,
  }) {
    if (namaBarang.isEmpty) {
      return {'error': 'Nama barang harus diisi'};
    }
    if (namaPeminjam.isEmpty) {
      return {'error': 'Nama peminjam harus diisi'};
    }
    if (total <= 0) {
      return {'error': 'Total harus lebih dari 0'};
    }
    if (tanggal.isAfter(DateTime.now())) {
      return {'error': 'Tanggal tidak boleh lebih dari hari ini'};
    }
    return null;
  }
}