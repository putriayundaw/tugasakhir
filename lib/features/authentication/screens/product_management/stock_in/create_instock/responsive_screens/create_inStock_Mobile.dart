import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/create_addproduct/widgets/create_addProduct_form.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/create_instock/widgets/create_inStock_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class CreateStockMobileScreen extends StatelessWidget {
  const CreateStockMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             TBreadcrumbsWithHeading(returnToPreviousScreen : true,heading: 'In stock', breadcrumbItems: [TRoutes.createinStock, 'Create In Stock']),
             SizedBox(height: TSizes.spaceBtwSections),

            //form
            CreateInStockForm(),
          ],
        ),),
      ),
    );
  }
}