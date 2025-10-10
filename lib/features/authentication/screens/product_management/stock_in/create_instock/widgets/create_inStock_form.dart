import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/common/widgets/images/image_uploader.dart';
import 'package:absensi/features/authentication/controller/productManagement/inStock_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CreateInStockForm extends StatefulWidget {
  const CreateInStockForm({super.key});

  @override
  _CreateInStockFormState createState() => _CreateInStockFormState();
}

class _CreateInStockFormState extends State<CreateInStockForm> {
  final InstockController _controller = InstockController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController parentProductController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  List<AllProductModel> _allProducts = [];
  List<AllProductModel> _filteredProducts = [];
  bool _isSearching = false;
  // String imageUrl = '';

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
      priceController.text = product.price.toString();      _searchController.text = product.name; // Juga mengisi search field
      _isSearching = false;
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
                                  subtitle: Text('Harga: \$${product.price}'),
                                  onTap: () => _selectProduct(product),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    
                    // // Product Name Field (akan terisi otomatis dari pencarian)
                    // TextFormField(
                    //   controller: productNameController,
                    //   readOnly: true, // Membuat field hanya baca saja
                    //   decoration: const InputDecoration(
                    //     labelText: 'Nama Produk',
                    //     border: OutlineInputBorder(),
                    //     prefixIcon: Icon(Iconsax.box),
                    //   ),
                    // ),
                    
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
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    // TextFormField(
                    //   controller: parentProductController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Parent Product (Optional)',
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
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
                  readOnly: true, // Membuat field hanya baca saja
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
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
                // Validate form
                if (productNameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    totalController.text.isEmpty) {
                  TLoaders.errorSnackBar(
                    title: 'Validation Error',
                    message: 'Please fill in all required fields',
                  );
                  return;
                }

                // Parse values
                double price;
                int total;
                try {
                  price = double.parse(priceController.text);
                  total = int.parse(totalController.text);
                } catch (e) {
                  TLoaders.errorSnackBar(
                    title: 'Validation Error',
                    message: 'Please enter valid numbers for price and stock',
                  );
                  return;
                }

                // Send to controller
                await _controller.createProduct(
                  productName: productNameController.text,
                  price: price,
                  total: total,
                  // parentProduct: parentProduActController.text,
                  description: descriptionController.text,
                  // imageUrl: imageUrl,
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