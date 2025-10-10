import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/outStock_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateOutStockForm extends StatefulWidget {
  const CreateOutStockForm({super.key});

  @override
  _CreateOutStockFormState createState() => _CreateOutStockFormState();
}

class _CreateOutStockFormState extends State<CreateOutStockForm> {
  final OutstockController _controller = Get.find(); // Gunakan Get.find() bukan instance baru
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController parentProductController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  List<AllProductModel> _allProducts = [];
  List<AllProductModel> _filteredProducts = [];
  bool _isSearching = false;
  double _selectedPrice = 0.0; // Tambahkan variabel untuk menyimpan harga

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    try {
      final products = await _controller.getAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
      });
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Gagal memuat data produk: $e',
      );
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectProduct(AllProductModel product) {
    setState(() {
      productNameController.text = product.name;
      priceController.text = product.price.toString(); // Konversi ke string
      _selectedPrice = product.price; // Simpan harga sebagai double
      _searchController.text = product.name;
      _isSearching = false;
      
      print('✅ Produk dipilih: ${product.name}');
      print('💰 Harga: ${product.price}');
      print('💰 Harga tersimpan: $_selectedPrice');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Right Column - Basic Information
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: TSizes.md),
                    
                    // Search field for products
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _searchController,
                          onChanged: _filterProducts,
                          decoration: const InputDecoration(
                            labelText: 'Cari Produk',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Iconsax.search_normal),
                          ),
                        ),
                        const SizedBox(height: TSizes.sm),
                        
                        // Dropdown for search results
                        if (_isSearching && _filteredProducts.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                return ListTile(
                                  title: Text(product.name),
                                  subtitle: Text('Harga: \$${product.price} | Stok: ${product.stock}'),
                                  onTap: () => _selectProduct(product),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    
                    
                  
                
                    TextFormField(
                      maxLines: 4,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Product Description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                 
                  
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TSizes.spaceBtwSections),
          Divider(height: 1, color: Colors.grey[300]),

          // Stock & Pricing Section
          const SizedBox(height: TSizes.spaceBtwSections),
          Text(
            'Stock & Pricing',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: TSizes.md),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: priceController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                    prefixIcon: Icon(Iconsax.dollar_circle),
                  ),
                ),
              ),
              
              const SizedBox(width: TSizes.spaceBtwInputFields),
              
              Expanded(
                child: TextFormField(
                  controller: totalController,
                  validator: (value) =>
                      TValidator.validateEmptyText('Stock', value),
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Iconsax.box),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TSizes.spaceBtwSections),
          Divider(height: 1, color: Colors.grey[300]),

          // Submit Button
          const SizedBox(height: TSizes.spaceBtwSections),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // DEBUG LOGGING
                print('🔄 Memulai proses create product...');
                print('📦 Data yang akan dikirim:');
                print('   - Nama: ${productNameController.text}');
                print('   - Harga: $_selectedPrice');
                print('   - Stock: ${totalController.text}');
                print('   - Deskripsi: ${descriptionController.text}');
                print('   - Parent: ${parentProductController.text}');

                // VALIDASI
                if (productNameController.text.isEmpty || 
                    totalController.text.isEmpty) {
                  TLoaders.errorSnackBar(
                    title: 'Validation Error',
                    message: 'Please fill in all required fields',
                  );
                  return;
                }

                if (_selectedPrice == 0.0) {
                  TLoaders.errorSnackBar(
                    title: 'Validation Error',
                    message: 'Please select a product with valid price',
                  );
                  return;
                }

                // PARSE STOCK
                int total;
                try {
                  total = int.parse(totalController.text);
                  if (total <= 0) {
                    TLoaders.errorSnackBar(
                      title: 'Validation Error',
                      message: 'Stock must be greater than 0',
                    );
                    return;
                  }
                } catch (e) {
                  TLoaders.errorSnackBar(
                    title: 'Validation Error',
                    message: 'Please enter valid number for stock',
                  );
                  return;
                }

                // PANGGIL CONTROLLER DENGAN SEMUA PARAMETER YANG DIPERLUKAN
                await _controller.createProduct(
                  productName: productNameController.text,
                  price: _selectedPrice,
                  total: total,
                  description: descriptionController.text,
  
                  context: context,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: TSizes.lg),
              ),
              child: const Text('Create Product', style: TextStyle(fontSize: 16)),
            ),
          ),
          
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    );
  }
}