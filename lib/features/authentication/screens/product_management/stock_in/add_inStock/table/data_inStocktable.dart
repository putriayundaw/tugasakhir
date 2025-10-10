import 'package:absensi/features/authentication/controller/productManagement/inStock_controller.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/models/inStock_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/table/table_inStocksource.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/widgets/header_instock.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InStockTable extends StatefulWidget {
  const InStockTable({super.key});

  @override
  _InStockTableState createState() => _InStockTableState();
}

class _InStockTableState extends State<InStockTable> {
  late InstockController _controller;
  late InProductRows _tableSource;
  final TextEditingController _searchController = TextEditingController();
  List<InStockProductModel> _allProducts = []; // Simpan semua produk
  List<InStockProductModel> _filteredProducts = []; // Produk setelah difilter

  @override
  void initState() {
    super.initState();
    _controller = Get.put(InstockController());
    _tableSource = InProductRows(
      product: _filteredProducts,
      controller: _controller,
      onDataChanged: _loadProducts,
    );
    _loadProducts();
    
    // Listen untuk perubahan search text
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    Get.delete<InstockController>();
    super.dispose();
  }

  // Method untuk handle search
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    
    if (query.isEmpty) {
      // Jika search kosong, tampilkan semua produk
      setState(() {
        _filteredProducts = List.from(_allProducts);
      });
    } else {
      // Filter produk berdasarkan query
      setState(() {
        _filteredProducts = _allProducts.where((product) {
          return product.product.toLowerCase().contains(query) ||
                 product.description.toLowerCase().contains(query) ||
                 product.price.toString().contains(query) ||
                 product.total.toString().contains(query);
        }).toList();
      });
    }
    
    // Update table source
    setState(() {
      _tableSource = InProductRows(
        product: _filteredProducts,
        controller: _controller,
        onDataChanged: _loadProducts,
      );
    });
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _controller.fetchProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = List.from(_allProducts); // Awalnya tampilkan semua
        _tableSource = InProductRows(
          product: _filteredProducts,
          controller: _controller,
          onDataChanged: _loadProducts,
        );
      });
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to load products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Header
        TTableHeaderInStock(
          buttonText: 'New Stock', 
          onPressed: () => Get.toNamed(TRoutes.createinStock),
          searchController: _searchController,
          onSearchChanged: (value) => _onSearchChanged(), // Callback untuk search
        ),
        const SizedBox(height: 16),
        
        // Data Table
        TPaginatedDataTable(
          minWidth: 900,
          columns: const [
            // DataColumn2(label: Text('Image'), fixedWidth: 80),
            DataColumn2(label: Text('Name')),
            DataColumn2(label: Text('Price')),
            DataColumn2(label: Text('Total')),
            DataColumn2(label: Text('Date')),
            DataColumn2(label: Text('Description'), size: ColumnSize.L),
            DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: _tableSource,
        ),
      ],
    );
  }
}