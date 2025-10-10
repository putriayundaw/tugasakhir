import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/responsive_screens/returned_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/responsive_screens/returned_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/responsive_screens/returned_Table.dart';
import 'package:flutter/material.dart';

class AddReturnedProductScreen  extends StatelessWidget {
  const AddReturnedProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: ReturnedProductDesktopScreen(), tablet:ReturnedProductTabletScreen (), mobile: ReturnedProductMobileScreen());
  }
}