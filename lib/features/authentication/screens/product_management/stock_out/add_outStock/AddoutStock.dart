import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/responsive_screens/inStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/responsive_screens/inStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/responsive_screens/inStock_Table.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/responsive_screens/outStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/responsive_screens/outStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/responsive_screens/outStock_Table.dart';
import 'package:flutter/material.dart';

class AddOutStockScreen  extends StatelessWidget {
  const AddOutStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: OutStockDesktopScreen(), tablet: OutstockTabletScreen(), mobile: OutStockMobileScreen());
  }
}