import 'package:absensi/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/create_borrowed/widgets/create_borrowed_form.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:flutter/material.dart';

class CreateBorrowedProductDesktopScreen extends StatelessWidget {
  const CreateBorrowedProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        TBreadcrumbsWithHeading (returnToPreviousScreen: true,  heading: 'BorrowedProduct', breadcrumbItems: [TRoutes.createborrowedProduct, 'BorrowedProduct']),
             SizedBox(height: TSizes.spaceBtwSections),

            //form body
            BorrowedProductForm(),
              
          ],
        ),),
      ),
    );
  }
}