import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/create_addproduct/widgets/create_addProduct_form.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/create_outstock/widgets/create_outStock_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class CreateOutStockTableScreen extends StatelessWidget {
  const CreateOutStockTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           TBreadcrumbsWithHeading(heading: 'In stock', breadcrumbItems: [TRoutes.createoutStock, 'Create In Stock']),
             SizedBox(height: TSizes.spaceBtwSections),

            //form body
             CreateOutStockForm(),
              
          ],
        ),),
      ),
    );
}
}