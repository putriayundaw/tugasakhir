import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/create_borrowed/widgets/create_borrowed_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class CreateBorrowedProductMobileScreen extends StatelessWidget {
  const CreateBorrowedProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TBreadcrumbsWithHeading(heading: ' Borrowed Product', breadcrumbItems: [TRoutes.createborrowedProduct, 'Create Borrowed Product']),
             SizedBox(height: TSizes.spaceBtwSections),

            //form
           BorrowedProductForm(),
          ],
        ),),
      ),
    );
  }
}