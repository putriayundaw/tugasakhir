// all_product_controller.dart
import 'dart:convert';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:http/http.dart' as http;

class AllProductController extends GetxController {
  static const String baseUrl = 'http://192.168.100.160:1880/OCN/all_products/ambil';
  
  // MinIO configuration
  static const String minioBaseUrl = 'http://192.168.100.160:9000';
  static const String minioBucket = 'ocn';

  // Reactive variables
  final RxList<AllProductModel> allProducts = <AllProductModel>[].obs;
  final RxList<AllProductModel> filteredProducts = <AllProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to search query changes with debounce
    debounce(searchQuery, (_) => filterProducts(), 
      time: const Duration(milliseconds: 300));
    loadProducts();
  }

  // Load all products
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      final products = await getProducts();
      allProducts.assignAll(products);
      filteredProducts.assignAll(products);
      
      // TLoaders.successSnackBar(
      //   title: 'Success',
      //   message: 'Products loaded successfully',
      // );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load products: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Filter products based on search query
  void filterProducts() {
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(allProducts);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredProducts.assignAll(
        allProducts.where((product) =>
          product.name.toLowerCase().contains(query) ||
          (product.price?.toString() ?? '').toLowerCase().contains(query) ||
          (product.stock?.toString() ?? '').toLowerCase().contains(query) ||
          (product.borrowed?.toString() ?? '').toLowerCase().contains(query) ||
          (product.returned?.toString() ?? '').toLowerCase().contains(query)
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

  // Get product by ID
  AllProductModel? getProductById(int id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get full image URL from MinIO
  String? getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }
    
    // Jika imagePath sudah berupa URL lengkap, return langsung
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    
    // Jika imagePath hanya nama file, build URL lengkap ke MinIO
    // Remove any leading slashes from the image path
    final cleanImagePath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    
    return '$minioBaseUrl/$minioBucket/$cleanImagePath';
  }

  // Check if image exists
  Future<bool> checkImageExists(String? imageUrl) async {
    if (imageUrl == null) return false;
    
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get available products (stock > 0)
  List<AllProductModel> getAvailableProducts() {
    return allProducts.where((product) => 
      (product.stock ?? 0) > 0
    ).toList();
  }

  // Default headers for the API request
  static Map<String, String> _defaultHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // Handle API response
  static List<AllProductModel> _handleResponse(http.Response response) {
    print('Request URL: ${response.request?.url}');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      
      // Check if the response is successful and contains data
      if (data['status'] == 'success' && data['data'] != null) {
        final List<dynamic> productsData = data['data'];
        return productsData.map((json) => AllProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${data['message']}');
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Client error: ${response.statusCode}');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    } else {
      throw Exception('Unexpected error: ${response.statusCode}');
    }
  }

  // Fetch all products
  static Future<List<AllProductModel>> getProducts() async {
    final url = Uri.parse(baseUrl);
    try {
      final response = await http.get(
        url, 
        headers: _defaultHeaders(),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      print('Client exception fetching products: $e');
      throw Exception('Network error: Please check your connection');
    } on FormatException catch (e) {
      print('Format exception fetching products: $e');
      throw Exception('Data format error: Invalid response from server');
    } on Exception catch (e) {
      print('Exception fetching products: $e');
      rethrow;
    }
  }

  // Dispose method to clean up resources
  @override
  void onClose() {
    // Cancel any ongoing debounce operations
    searchQuery.close();
    super.onClose();
  }
}