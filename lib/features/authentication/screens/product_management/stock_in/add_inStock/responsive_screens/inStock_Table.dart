import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/widgets/table_header.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/table/data_inStocktable.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/widgets/header_instock.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddInStockTabletScreen extends StatelessWidget {
  const AddInStockTabletScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true, 
                heading: 'inStock', 
                breadcrumbItems: ['InStock']
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table body
              TRoundedContainer(
                child: Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Table (sekarang search ada di dalam InStockTable)
                    InStockTable(),
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