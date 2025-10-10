import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/responsive_screens/edit_AddProduct_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/responsive_screens/edit_AddProduct_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/responsive_screens/edit_AddProduct_Tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EditAddProductScreen extends StatelessWidget {
  const EditAddProductScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    
   final products = ProductModel(id: '', imageUrl: '', name: '', price: '' , total: '',);

    return  TSiteTemplate(
      desktop: EditAddProductDesktopScreen(product:products ),
      tablet: EditAddProductTabletScreen(product:products),
      mobile: EditAddProductMobileScreen(product:products),
    );
  }
}