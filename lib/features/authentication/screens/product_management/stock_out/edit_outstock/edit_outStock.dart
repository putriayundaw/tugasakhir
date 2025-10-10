import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/responsive_screens/edit_inStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/responsive_screens/edit_inStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/responsive_screens/edit_inStock_Tablet.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/edit_outstock/responsive_screens/edit_outStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/edit_outstock/responsive_screens/edit_outStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/edit_outstock/responsive_screens/edit_outStock_Tablet.dart';
import 'package:flutter/material.dart';


class EditOutStockScreen extends StatelessWidget {
  const EditOutStockScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    
    final products = ProductModel(id: '', imageUrl: '', name: '', price: '', total: '');

    return  TSiteTemplate(
      desktop: EditOutStockDesktopScreen(products:products ),
      tablet: EditOutStockTabletScreen(products:products),
      mobile: EditOutStockMobileScreen(products:products),
    );
  }
}