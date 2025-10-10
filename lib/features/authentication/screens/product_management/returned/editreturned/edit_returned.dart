import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/models/returned_models.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/editreturned/responsive_screens/edit_returned_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/editreturned/responsive_screens/edit_returned_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/editreturned/responsive_screens/edit_returned_Tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EditReturneddProductScreen extends StatelessWidget {
  const EditReturneddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final returnedItem = Get.arguments as ReturnedProductModels;
    return TSiteTemplate(
      desktop: EditReturnedProductDesktopScreen(returnedItem: returnedItem),
      tablet: EditReturnedProductTabletScreen(returnedItem: returnedItem),
      mobile: EditReturnedProductMobileScreen(returnedItem: returnedItem),
    );
  }
}
