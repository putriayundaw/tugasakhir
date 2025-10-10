import 'package:flutter/material.dart';
import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/widgets/edit_Addproduct_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';

class EditAddProductDesktopScreen extends StatelessWidget {
  const EditAddProductDesktopScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menambahkan AppBar dengan tombol kembali dan judul
      appBar: AppBar(
        title: const Text('Edit Product'), // Judul pada bagian atas
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Tombol kembali
        ),
      ),
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
              EditAddProductForm(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
