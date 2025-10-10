import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/addproduct_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/data_table.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddProductsMobileScreen extends StatefulWidget {
  const AddProductsMobileScreen({super.key});

  @override
  _AddProductsMobileScreenState createState() => _AddProductsMobileScreenState();
}

class _AddProductsMobileScreenState extends State<AddProductsMobileScreen> {
  final ProductsController controller = Get.put(ProductsController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      controller.updateSearchQuery(_searchController.text);
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.searchQuery.value.isNotEmpty) {
        _searchController.text = controller.searchQuery.value;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                heading: 'AddProducts',
                breadcrumbItems: ['AddProducts'],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              TRoundedContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tombol Add New Product
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.toNamed(TRoutes.createAddProduct),
                            icon: const Icon(Iconsax.add),
                            label: const Text('Create New Products'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        // Search Field
                        TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Products',
                            prefixIcon: const Icon(Iconsax.search_normal),
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _searchController.clear();
                                controller.clearSearch();
                              },
                              icon: const Icon(Iconsax.close_circle, size: 16),
                              tooltip: 'Clear Search',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Tabel Products
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      if (controller.filteredProducts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              Text(
                                controller.searchQuery.value.isEmpty
                                    ? 'No products found'
                                    : 'No products found for "${controller.searchQuery.value}"',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              if (controller.searchQuery.value.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    controller.clearSearch();
                                  },
                                  child: const Text('Clear search'),
                                ),
                            ],
                          ),
                        );
                      }

                      return AddProductsTable(products: controller.filteredProducts);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}