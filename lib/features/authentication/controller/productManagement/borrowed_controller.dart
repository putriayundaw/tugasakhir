import 'dart:convert';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/popups/full_screen_loader.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BorrowedProductController extends GetxController {
  static const String baseUrl = 'http://192.168.100.160:1880';

  final RxList<BorrowedProductModels> allProducts = <BorrowedProductModels>[].obs;
  final RxList<BorrowedProductModels> filteredProducts = <BorrowedProductModels>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to search query changes with debounce
    debounce(searchQuery, (_) => filterProducts(), 
      time: const Duration(milliseconds: 300));
    loadProducts();
  }

  // Getter untuk URL fetch products
  String get fetchProductsUrl => '$baseUrl/OCN/peminjaman_barang/ambil';

  // Load all products
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final products = await fetchBorrowedProducts();
      allProducts.assignAll(products);
      filteredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load borrowed products: $e',
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
          product.total.toString().contains(query) ||
          (product.deskripsi?.toLowerCase().contains(query) ?? false)
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

  // Method to fetch borrowed products
  Future<List<BorrowedProductModels>> fetchBorrowedProducts() async {
    try {
      final response = await http.get(Uri.parse(fetchProductsUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          if (data['data'] is List) {
            final List<dynamic> productList = data['data'];
            return productList
                .map((json) => BorrowedProductModels.fromJson(json))
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
      print('Error in fetchBorrowedProducts: $e');
      throw Exception('Error fetching borrowed products: $e');
    }
  }

  // GET - Ambil data produk untuk dropdown
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
        
        // Debug: Print response structure
        print('Response data type: ${responseData.runtimeType}');
        
        // Handle berbagai format response
        List<dynamic> productsList = [];
        
        if (responseData is List) {
          productsList = responseData;
          print('Response is List, length: ${productsList.length}');
        } else if (responseData is Map && responseData['data'] is List) {
          productsList = responseData['data'];
          print('Response has data key, length: ${productsList.length}');
        } else if (responseData is Map && responseData['status'] == 'success' && responseData['data'] is List) {
          productsList = responseData['data'];
          print('Response has status success, length: ${productsList.length}');
        } else {
          print('Unexpected response format: $responseData');
          throw Exception('Invalid response format: ${response.body}');
        }

        // Convert to AllProductModel
        List<AllProductModel> products = productsList.map((product) {
          if (product is Map<String, dynamic>) {
            return AllProductModel.fromJson(product);
          } else {
            throw Exception('Invalid product data format: $product');
          }
        }).toList();

        print('Successfully parsed ${products.length} products');
        return products;
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Failed to load products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in fetchProducts: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Method untuk delete borrowed product
  static Future<Map<String, dynamic>> deleteBorrowedProduct(int id) async {
    try {
      final url = Uri.parse('$baseUrl/OCN/peminjaman_barang/hapus?id=$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Product deleted successfully'
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Failed to delete product'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // POST - Tambah data peminjaman
  static Future<Map<String, dynamic>> addBorrowedProduct(BorrowedProductModels product) async {
    try {
      final payload = product.toJson();
      print('Sending payload: $payload');

      final response = await http.post(
        Uri.parse('$baseUrl/OCN/peminjaman_barang/tambah'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      print('Add borrowed response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Menampilkan loader dan snack bar setelah berhasil
        TFullScreenLoader.stopLoading();
        TLoaders.successSnackBar(title: 'Peminjaman berhasil ditambahkan', message: responseData['message'] ?? 'Berhasil');

        // Navigasi menggunakan GetX
        Get.toNamed(TRoutes.borrowedProduct); // Arahkan ke halaman yang sesuai

        return {
          'success': true,
          'message': responseData['message'] ?? 'Peminjaman berhasil ditambahkan',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      // Jika terjadi error
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(message: 'Error: $e', title: null);
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // GET semua data peminjaman
  static Future<List<BorrowedProductModels>> getBorrowedProducts({int? id}) async {
    try {
      String endpoint = '/OCN/peminjaman_barang/ambil';
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
            return (responseData['data'] as List).map((item) => BorrowedProductModels.fromJson(item)).toList();
          } else {
            throw Exception('Data format is not list');
          }
        } else {
          throw Exception('Invalid response structure: ${response.body}');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT - Edit data peminjaman
  static Future<Map<String, dynamic>> updateBorrowedProduct(BorrowedProductModels product) async {
    try {
      final payload = product.toJson();
      print('Sending update payload: $payload');

      final response = await http.put(
        Uri.parse('$baseUrl/OCN/peminjaman_barang/edit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      print('Update borrowed response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        TLoaders.successSnackBar(title: 'Berhasil', message: responseData['message'] ?? 'Peminjaman berhasil diperbarui');

        return {
          'success': true,
          'message': responseData['message'] ?? 'Peminjaman berhasil diperbarui',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Terjadi kesalahan',
        };
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Gagal memperbarui peminjaman: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Validasi data
  static Map<String, String>? validateBorrowedProduct(
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