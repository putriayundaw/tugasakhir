import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/responsive_screens/borrowed_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/responsive_screens/borrowed_Mobile.dart' hide BorrowedProductDesktopScreen;
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/responsive_screens/borrowed_Table.dart' hide BorrowedProductDesktopScreen;
import 'package:flutter/material.dart';

class AddBorrowedProductScreen  extends StatelessWidget {
  const AddBorrowedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: BorrowedProductDesktopScreen(), tablet: BorrowedProductMobileScreen(), mobile: BorrowedProductMobileScreen());
  }
}