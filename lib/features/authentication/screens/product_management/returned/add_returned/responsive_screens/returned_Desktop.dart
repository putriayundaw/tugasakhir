import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/productManagement/returned_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/table/data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/widgets/header_returned.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReturnedProductDesktopScreen extends StatefulWidget {
  const ReturnedProductDesktopScreen({super.key});

  @override
  _ReturnedProductDesktopScreenState createState() => _ReturnedProductDesktopScreenState();
}

class _ReturnedProductDesktopScreenState extends State<ReturnedProductDesktopScreen> {
  final ReturnedProductController controller = Get.put(ReturnedProductController());
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
                heading: 'Returned Product', 
                breadcrumbItems: ['Returned Product']
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                child: Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Header dengan search
                    TTableHeaderReturned(
                      buttonText: 'Add Returned Product', 
                      onPressed: () => Get.toNamed(TRoutes.createreturnedProduct),
                      searchController: _searchController,
                      onSearchChanged: (value) {
                        // Tidak perlu setState, sudah dihandle oleh listener
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Tabel dengan reactive data
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
                                    ? 'No returned products found' 
                                    : 'No returned products found for "${controller.searchQuery.value}"',
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

                      return ReturnedProductsTable(products: controller.filteredProducts);
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