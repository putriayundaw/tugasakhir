import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/responsive_screens/inStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/responsive_screens/inStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/responsive_screens/inStock_Table.dart';
import 'package:flutter/material.dart';

class InStockScreen extends StatelessWidget {
  const InStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: AddInStockDesktopScreen(), tablet: AddInStockTabletScreen(), mobile: AddInStockMobileScreen());
  }
}