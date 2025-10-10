// ignore: unused_import
import 'package:absensi/data/models/order_model.dart';
import 'package:absensi/features/authentication/controller/productManagement/allProduct_controller.dart';
import 'package:absensi/features/authentication/controller/productManagement/inStock_controller.dart';
import 'package:absensi/features/authentication/controller/productManagement/outStock_controller.dart';
import 'package:absensi/features/authentication/controller/productManagement/borrowed_controller.dart';
import 'package:absensi/features/authentication/controller/productManagement/returned_controller.dart';
import 'package:get/get.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';

class DashboardController extends GetxController{
  static DashboardController get instance => Get.put(DashboardController());

  final UserService userService = Get.find<UserService>();

  final RxList<double> weeklyProductAdditions = <double>[].obs;
  final RxMap<String, int> productStats = <String, int>{}.obs;

  final AllProductController productController = Get.put(AllProductController());
  final InstockController inStockController = Get.put(InstockController());
  final OutstockController outStockController = Get.put(OutstockController());
  final BorrowedProductController borrowedController = Get.put(BorrowedProductController());
  final ReturnedProductController returnedController = Get.put(ReturnedProductController());

  final RxInt totalStockIn = 0.obs;
  final RxInt totalStockOut = 0.obs;
  final RxInt totalBorrowed = 0.obs;
  final RxInt totalReturned = 0.obs;

  final RxInt totalUsers = 0.obs;
  final RxInt smkBrantasUsersCount = 3.obs;
  final RxInt smknNglegokUsersCount = 2.obs;

  @override  
  void onInit(){
    super.onInit();

    print('DashboardController onInit called');

    // Load data awal
    loadAllData();
    

    // Listen perubahan data dan update total
    ever(inStockController.products, (_) => updateTotals());
    ever(outStockController.outStockProducts, (_) => updateTotals());
    ever(borrowedController.allProducts, (_) => updateTotals());
    ever(returnedController.allProducts, (_) => updateTotals());

    // Listen changes in userService.users to update counts reactively
    ever(userService.reactiveUsers, (_) {
      print('Detected change in userService.reactiveUsers, refreshing user counts');
     
    });
  }
  
  Future<void> loadAllData() async {
    await inStockController.fetchProducts();
    await outStockController.fetchProducts();
    await borrowedController.loadProducts();
    await returnedController.loadProducts();
    updateTotals();
  }

 

  void updateTotals() {
    totalStockIn.value = inStockController.products.length;
    totalStockOut.value = outStockController.outStockProducts.length;
    totalBorrowed.value = borrowedController.allProducts.length;
    totalReturned.value = returnedController.allProducts.length;
  }

  // Existing methods unchanged...

  // Calculate weekly product additions - JUMLAH PRODUK BUKAN STOCK
  void _calculateWeeklyProductAdditions() {
    try {
      print('🔄 Calculating weekly product additions...');
      
      // Reset ke 0
      weeklyProductAdditions.value = List<double>.filled(7, 0.0);

      final products = productController.allProducts;
      
      if (products.isEmpty) {
        print('❌ No products found');
        return;
      }

      print('📦 Total products available: ${products.length}');

      // Get current week start (Monday)
      final DateTime now = DateTime.now();
      final DateTime weekStart = _getStartOfWeek(now);

      print('📅 Current week start: $weekStart');

      for (var product in products) {
        // Gunakan createdAt jika ada, jika tidak gunakan tanggal default
        DateTime? productDate = product.createdAt;
        
        if (productDate == null) {
          // Jika tidak ada createdAt, skip atau gunakan tanggal default
          continue;
        }

        // Check if the product is within the current week
        if (productDate.isAfter(weekStart.subtract(const Duration(days: 1))) && 
            productDate.isBefore(weekStart.add(const Duration(days: 7)))) {
          
          // Pastikan index dalam range 0-6
          int index = (productDate.weekday - 1) % 7;
          if (index >= 0 && index < 7) {
            weeklyProductAdditions[index] += 1; // Hitung jumlah produk, bukan stock
            
            print('✅ Product counted: ${product.name} on ${_getDayName(productDate.weekday)}, index: $index');
          }
        }
      }

      print('📊 Final Weekly Product Additions: $weeklyProductAdditions');
    } catch (e) {
      print('❌ Error calculating weekly product additions: $e');
    }
  }

  void _calculateProductStats() {
    try {
      productStats.clear();
      final products = productController.allProducts;
      
      // Hitung total produk
      productStats['total_products'] = products.length;
      
      // // Hitung produk featured
      // productStats['featured_products'] = products.where((product) => product.isFeatured == true).length;
      
      // Hitung produk dengan stok rendah
      productStats['low_stock_products'] = products.where((product) => (product.stock ?? 0) < 10).length;
      
      print('📈 Product Stats: $productStats');
    } catch (e) {
      print('❌ Error calculating product stats: $e');
    }
  }

  DateTime _getStartOfWeek(DateTime date) {
    // Kembalikan ke hari Senin (weekday 1)
    return date.subtract(Duration(days: date.weekday - 1));
  }

  String _getDayName(int weekday) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1) % 7];
  }

  // Refresh data
  void refreshProductData() {
    print('🔄 Manual refresh triggered');
    productController.loadProducts().then((_) {
      _calculateWeeklyProductAdditions();
      _calculateProductStats();
    });
  }
}