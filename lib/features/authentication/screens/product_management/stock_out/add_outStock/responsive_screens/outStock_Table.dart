import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/widgets/table_header.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/table/data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/widgets/header_outStock.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OutstockTabletScreen extends StatelessWidget {
  const OutstockTabletScreen({super.key});

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
                heading: 'Out Stock', 
                breadcrumbItems: ['Out Stock']
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Table body
              TRoundedContainer(
                child: Column(
                  children: [
                    const SizedBox(height: TSizes.spaceBtwItems),
                    
                    // Table (header sudah termasuk di dalam AddOutStockTable)
                    AddOutStockTable(),
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