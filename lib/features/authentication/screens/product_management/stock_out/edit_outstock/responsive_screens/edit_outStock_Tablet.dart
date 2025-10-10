import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/widgets/edit_Addproduct_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class EditOutStockTabletScreen extends StatelessWidget {
  const EditOutStockTabletScreen({
    super.key,
    required this.products, // Pastikan parameter 'products' diterima dengan benar
  });

  final ProductModel products; // Properti 'products' dideklarasikan sebagai final

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:const  EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Product',
                breadcrumbItems: [
                  TRoutes.addProduct,
                  'Update AddProducts'
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditAddProductForm(product: products),
            ],
          ),
        ),
      ),
    );
  }
}
