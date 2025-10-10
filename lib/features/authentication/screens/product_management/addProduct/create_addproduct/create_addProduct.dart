import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/create_addproduct/responsive_screens/createProduct_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/create_addproduct/responsive_screens/createProduct_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/create_addproduct/responsive_screens/createProduct_Table.dart';
import 'package:flutter/material.dart';

class CreateAddProductScreen extends StatelessWidget {
  const CreateAddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: CreateProductDesktopScreen(),tablet: CreateProductTableScreen(),mobile: CreateProductMobileScreen());
  }
}