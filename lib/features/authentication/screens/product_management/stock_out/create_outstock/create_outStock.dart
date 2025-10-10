import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/create_outstock/responsive_screens/create_outStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/create_outstock/responsive_screens/create_outStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/create_outstock/responsive_screens/create_outStock_Table.dart';
import 'package:flutter/material.dart';

class CreateOutstock extends StatelessWidget {
  const CreateOutstock({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: CreateOutStockDesktopScreen(),tablet: CreateOutStockTableScreen(),mobile: CreateOutStockMobileScreen());
  }
}