import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/edit_borrowed/widgets/edit_borrowed_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class EditBorrowedProductTabletScreen extends StatelessWidget {
  const EditBorrowedProductTabletScreen({
    super.key,
    required this.borrowedItem,
  });

  final BorrowedProductModels borrowedItem;

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
                returnToPreviousScreen: true,
                heading: 'Edit Peminjaman Barang',
                breadcrumbItems: [
                  TRoutes.borrowedProduct,
                  'Edit Peminjaman'
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditBorrowedProductForm(borrowedItem: borrowedItem),
            ],
          ),
        ),
      ),
    );
  }
}
