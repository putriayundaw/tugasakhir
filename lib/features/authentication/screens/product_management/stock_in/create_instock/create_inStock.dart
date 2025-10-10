import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/create_instock/responsive_screens/create_inStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/create_instock/responsive_screens/create_inStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/create_instock/responsive_screens/create_inStock_Table.dart';
import 'package:flutter/material.dart';

class CreateInstock extends StatelessWidget {
  const CreateInstock({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: CreateStockDesktopScreen(),tablet: CreateStockTableScreen(),mobile: CreateStockMobileScreen());
  }
}