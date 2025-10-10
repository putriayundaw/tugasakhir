import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/services/minio_service.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/popups/full_screen_loader.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class ProductsController extends GetxController {
  static ProductsController get instance => Get.find();

  // API URLs - SESUAI NODE-RED
  final String apiUrl = 'http://192.168.100.160:1880/OCN/tambah_produk/tambah';
  final String getApiUrl = 'http://192.168.100.160:1880/OCN/tambah_produk/ambil';
  final String updateApiUrl = 'http://192.168.100.160:1880/OCN/tambah_produk/edit';
  final String deleteApiUrl = 'http://192.168.100.160:1880/OCN/tambah_produk/hapus';

  // Reactive variables
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  
  // Untuk menyimpan gambar yang dipilih (support web & mobile)
  final Rx<File?> selectedImageFile = Rx<File?>(null);
  final Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);
  final RxString selectedImageName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => filterProducts(), 
      time: const Duration(milliseconds: 300));
    loadProducts();
  }

  // Method untuk memilih gambar dari gallery (support web & mobile)
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        selectedImageName.value = image.name;
        
        // Untuk web, baca sebagai bytes
        final bytes = await image.readAsBytes();
        selectedImageBytes.value = bytes;
        
        // Untuk mobile, simpan sebagai File
        if (!kIsWeb) {
          selectedImageFile.value = File(image.path);
        }
        
        print('✅ Gambar dipilih: ${image.name}');
      }
    } catch (e) {
      print('❌ Error pick image: $e');
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to pick image: $e');
    }
  }



  // Method untuk menghapus gambar yang dipilih
  void clearImage() {
    selectedImageFile.value = null;
    selectedImageBytes.value = null;
    selectedImageName.value = '';
  }

  // Check if image is selected
  bool get isImageSelected => selectedImageBytes.value != null || selectedImageFile.value != null;

  // Load all products
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final products = await getProducts();
      allProducts.assignAll(products);
      filteredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load products: $e',
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
          product.name.toLowerCase().contains(query) ||
          product.price.toLowerCase().contains(query) ||
          product.total.toString().toLowerCase().contains(query) ||
          (product.parentProduct?.toLowerCase() ?? '').contains(query)
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
  }

// GET Products
Future<List<ProductModel>> getProducts() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.100.160:1880/OCN/tambah_produk/ambil'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        if (data['data'] != null && data['data'] is List) {
          List<ProductModel> products = (data['data'] as List).map((productJson) {
            return ProductModel.fromJson(productJson);
          }).toList();
          return products;
        } else {
          throw Exception('Data produk tidak ditemukan atau format tidak sesuai');
        }
      } else {
        throw Exception('Gagal memuat produk: ${data['message']}');
      }
    } else {
      throw Exception('Gagal memuat produk: Status code ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error fetching products: $e');
    throw Exception('Kesalahan saat mengambil produk: $e');
  }
}

  // CREATE Product - 
// CREATE Product - Upload ke MinIO sesuai alur Node-RED
Future<void> createProduct({
  required String productName,
  required String price,
  required String total,
  required String parentProduct,
  required bool isFeatured,
  required BuildContext context,
}) async {
  try {
    print('🔄 Starting product creation process...');

    // Validasi input
    if (productName.isEmpty || price.isEmpty || total.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Validation Error',
        message: 'Please fill all required fields',
      );
      return;
    }

    // Test MinIO connection first
    print('🔗 Testing MinIO connection...');
    MinioService minioService = MinioService();
    bool minioConnected = await minioService.testMinIOConnection();
    
    if (!minioConnected) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Connection Error',
        message: 'Cannot connect to MinIO server',
      );
      return;
    }

    String? imagePath;

    // Upload gambar ke MinIO jika ada gambar yang dipilih
    if (isImageSelected) {
      print('📸 Uploading image to MinIO...');
      try {
        imagePath = await minioService.uploadImageToMinIO(
          imageBytes: selectedImageBytes.value,
          imageFile: selectedImageFile.value,
          imageName: selectedImageName.value,
          isWeb: kIsWeb,
        );
        
        if (imagePath == null) {
          throw Exception('Failed to get image path from MinIO');
        }
        
        print('✅ Image uploaded successfully. Path: $imagePath');
      } catch (e) {
        TFullScreenLoader.stopLoading();
        print('❌ Image upload failed: $e');
        TLoaders.errorSnackBar(
          title: 'Upload Failed',
          message: 'Failed to upload image: $e',
        );
        return;
      }
    } else {
      print('ℹ️ No image selected, proceeding without image');
      imagePath = ''; // Set empty string if no image
    }

    // Buat multipart request ke Node-RED - SESUAI DENGAN ALUR NODE-RED
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Tambahkan fields sesuai dengan yang diharapkan Node-RED
    request.fields['nama_barang'] = productName;
    request.fields['harga'] = price;
    request.fields['total'] = total;
    request.fields['parent_addproduct'] = parentProduct;
    request.fields['featured'] = isFeatured ? '1' : '0';
    
    // Kirim image path jika ada (sesuai dengan msg.fileName di Node-RED)
    if (imagePath != null && imagePath.isNotEmpty) {
      request.fields['fileName'] = imagePath;
     
    }

    print('📦 Sending data to Node-RED:');
    print('  - nama_barang: $productName');
    print('  - harga: $price');
    print('  - total: $total');
    print('  - parent_addproduct: $parentProduct');
    print('  - featured: ${isFeatured ? '1' : '0'}');
    print('  - fileName: $imagePath');
  

    // Juga tambahkan file gambar sebagai multipart (untuk backup)
    if (isImageSelected) {
      print('📸 Adding image file to multipart...');
      
      if (kIsWeb && selectedImageBytes.value != null) {
        final bytes = selectedImageBytes.value!;
        final mimeType = lookupMimeType('', headerBytes: bytes) ?? 'image/jpeg';
        final extension = mimeType.split('/')[1];
        
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: selectedImageName.value.isNotEmpty 
              ? selectedImageName.value 
              : '${DateTime.now().millisecondsSinceEpoch}.$extension',
          contentType: MediaType('image', extension),
        ));
        
      } else if (!kIsWeb && selectedImageFile.value != null) {
        final file = selectedImageFile.value!;
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
        final extension = mimeType.split('/')[1];
        
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          file.path,
          filename: selectedImageName.value.isNotEmpty 
              ? selectedImageName.value 
              : '${DateTime.now().millisecondsSinceEpoch}.$extension',
          contentType: MediaType('image', extension),
        ));
      }
    }

    // Kirim request
    print('📤 Sending request to Node-RED: $apiUrl');
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    TFullScreenLoader.stopLoading();

    print('📥 Node-RED Response status: ${response.statusCode}');
    print('📥 Node-RED Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        TLoaders.successSnackBar(
          title: 'Success!', 
          message: data['message'] ?? 'Product added successfully'
        );
        
        // Clear selected image setelah berhasil
        clearImage();
        
        // Reload products setelah berhasil create
        await loadProducts();
        
        // Navigate back
        Get.offNamed(TRoutes.addProduct); 
      } else {
        final errorMsg = data['message'] ?? data['error'] ?? 'Unknown error occurred';
        TLoaders.errorSnackBar(
          title: 'Failed',
          message: errorMsg,
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
    print('❌ Exception in createProduct: $e');
    TLoaders.errorSnackBar(
      title: 'Error',
      message: 'Failed to create product: ${e.toString()}',
    );
  }
}

  // UPDATE Product
  Future<bool> updateProduct({
    required String productId,
    required String productName,
    required String price,
    required String total,
    required String parentProduct,
    required BuildContext context,
  }) async {
    try {
      if (productName.isEmpty || price.isEmpty || total.isEmpty) {
        TLoaders.errorSnackBar(
          title: 'Validation Error',
          message: 'Please fill all required fields',
        );
        return false;
      }

      final Map<String, dynamic> productData = {
        'id': int.parse(productId),
        'nama_barang': productName,
        'harga': int.parse(price),
        'total': int.parse(total),
        'parent_addproduct': parentProduct,
      };

     
      final response = await http.put(
        Uri.parse(updateApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      TFullScreenLoader.stopLoading();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // TLoaders.successSnackBar(
          //   title: 'Update Successful', 
          //   message: data['message'] ?? 'Product updated successfully'
          // );
          // Reload products setelah berhasil update
          await loadProducts();
          return true;
        } else {
          TLoaders.errorSnackBar(
            title: 'Update Failed',
            message: data['message'] ?? 'Unknown error occurred',
          );
          return false;
        }
      } else {
        TLoaders.errorSnackBar(
          title: 'Server Error',
          message: 'Server returned status code ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Error: ${e.toString()}',
      );
      return false;
    }
  }

  // DELETE Product
  Future<bool> deleteProduct({required String productId, required BuildContext context}) async {
    try {
      final url = Uri.parse('$deleteApiUrl?id=$productId');
      
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          // Reload products setelah berhasil delete
          await loadProducts();
          return true;
        } else {
          throw Exception(data['message'] ?? 'Delete failed');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid product ID');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout');
    } on http.ClientException {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }
}