import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/models/returned_models.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/editreturned/widgets/edit_returned_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class EditReturnedProductMobileScreen extends StatelessWidget {
  const EditReturnedProductMobileScreen({
    super.key,
    required this.returnedItem,
  });

  final ReturnedProductModels returnedItem;

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
                heading: 'Edit Pengembalian Barang',
                breadcrumbItems: [
                  TRoutes.returnedProduct,
                  'Edit Pengembalian'
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              EditReturnedProductForm(returnedItem: returnedItem),
            ],
          ),
        ),
      ),
    );
  }
}
