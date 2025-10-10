

import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/create_returned/responsive_screens/create_returned_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/create_returned/responsive_screens/create_returned_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/create_returned/responsive_screens/create_returned_Table.dart';
import 'package:flutter/material.dart';

class CreateReturnedProductScreen extends StatelessWidget {
  const CreateReturnedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: CreateReturnedProductDesktopScreen(),tablet: CreateReturnedProductTableScreen(),mobile: CreateReturnedProductMobileScreen());
  }
}