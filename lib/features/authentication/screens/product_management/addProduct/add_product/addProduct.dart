import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/responsive_screens/addProduct_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/responsive_screens/addProduct_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/responsive_screens/addProduct_Table.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: AddProductsDesktopScreen(), tablet: AddProductsTabletScreen(), mobile: AddProductsMobileScreen());
  }
}