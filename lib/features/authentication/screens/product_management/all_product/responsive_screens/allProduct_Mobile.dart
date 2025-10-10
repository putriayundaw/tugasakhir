import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/allProduct_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/table/data_table.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class AllProductsMobileScreen extends StatefulWidget {
  const AllProductsMobileScreen({super.key});

  @override
  _AllProductsMobileScreenState createState() => _AllProductsMobileScreenState();
}

class _AllProductsMobileScreenState extends State<AllProductsMobileScreen> {
  final AllProductController controller = Get.put(AllProductController()); // Gunakan AllProductController
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
                heading: 'All Products', // Perbaiki heading
                breadcrumbItems: ['All Products'] // Perbaiki breadcrumb
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                child: Column(
                  children: [
                    // Tambahkan Table Header untuk Desktop
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
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
                        ),
                      ],
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

                      return AllProductsTable(products: controller.filteredProducts);
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