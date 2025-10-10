import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/responsive_screens/allProduct_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/responsive_screens/allProduct_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/responsive_screens/allProduct_Table.dart';
import 'package:flutter/material.dart';

class AllProductScreen extends StatelessWidget {
  const AllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: AllProductsDesktopScreen(), tablet: AllProductsTabletScreen(), mobile: AllProductsMobileScreen());
  }
}