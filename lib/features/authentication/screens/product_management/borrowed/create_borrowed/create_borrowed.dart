

import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/create_borrowed/responsive_screens/create_borrowed_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/create_borrowed/responsive_screens/create_borrowed_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/create_borrowed/responsive_screens/create_borrowed_Table.dart';
import 'package:flutter/material.dart';

class CreateBorrowedProductScreen extends StatelessWidget {
  const CreateBorrowedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: CreateBorrowedProductDesktopScreen(),tablet: CreateBorrowedProductTableScreen(),mobile: CreateBorrowedProductMobileScreen());
  }
}