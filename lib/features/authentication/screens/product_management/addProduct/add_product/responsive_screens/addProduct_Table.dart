import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/addproduct_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/widgets/table_header.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddProductsTabletScreen extends StatefulWidget {
  const AddProductsTabletScreen({super.key});

  @override
  _AddProductsTabletScreenState createState() => _AddProductsTabletScreenState();
}

class _AddProductsTabletScreenState extends State<AddProductsTabletScreen> {
  final ProductsController controller = Get.put(ProductsController());
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Sync controller dengan search query
    _searchController.addListener(() {
      controller.updateSearchQuery(_searchController.text);
    });
    
    // Set initial value jika ada
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
                  breadcrumbItems: ['AddProducts']
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                child: Column(
                  children: [
                    // GUNAKAN _searchController YANG SAMA, TIDAK BUAT BARU
                    TAddProductsTableHeader(
                      buttonText: 'Create New Products',
                      onPressed: () => Get.toNamed(TRoutes.createAddProduct),
                      searchController: _searchController, // Gunakan instance yang sama
                      searchOnChanged: (value) {
                        // Tidak perlu setState, sudah dihandle oleh listener
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      if (controller.filteredProducts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}