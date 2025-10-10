import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/widgets/edit_Addproduct_form.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/models/inStock_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/widgets/edit_inStock_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class EditInStockDesktopScreen extends StatelessWidget {
  const EditInStockDesktopScreen({
    super.key,
    required this.products, // Menggunakan required dan menyesuaikan tipe data
  });

  final  InStockProductModel products; // Properti yang menyimpan data produk

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Product',
                breadcrumbItems: [
                  TRoutes.addProduct,
                  'Update AddProducts',
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form untuk mengedit produk
              EditInStockForm(product: products),
            ],
          ),
        ),
      ),
    );
  }
}
