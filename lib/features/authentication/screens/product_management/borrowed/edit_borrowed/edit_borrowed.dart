import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/edit_borrowed/responsive_screens/edit_borrowed_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/edit_borrowed/responsive_screens/edit_borrowed_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/edit_borrowed/responsive_screens/edit_borrowed_Tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditBorrowedProductScreen extends StatelessWidget {
  const EditBorrowedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data borrowed item dari arguments
    final BorrowedProductModels borrowedItem = Get.arguments;

    return TSiteTemplate(
      desktop: EditBorrowedProductDesktopScreen(borrowedItem: borrowedItem),
      tablet: EditBorrowedProductTabletScreen(borrowedItem: borrowedItem),
      mobile: EditBorrowedProductMobileScreen(borrowedItem: borrowedItem),
    );
  }
}
