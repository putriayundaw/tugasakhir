import 'package:absensi/common/widgets/layouts/templates/site_layout.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/models/inStock_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/responsive_screens/edit_inStock_Desktop.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/responsive_screens/edit_inStock_Mobile.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/responsive_screens/edit_inStock_Tablet.dart';
import 'package:flutter/material.dart';


class EditInStockScreen extends StatelessWidget {
  const EditInStockScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    
    final products = InStockProductModel(id: '', imageUrl: '', product: '', price: 0 ,total: 0, description: '', );

    return  TSiteTemplate(
      desktop: EditInStockDesktopScreen(products:products ),
      tablet: EditInStockTabletScreen(products:products),
      mobile: EditInStockMobileScreen(products:products),
    );
  }
}