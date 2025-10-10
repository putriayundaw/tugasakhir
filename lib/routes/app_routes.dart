import 'package:absensi/features/authentication/screens/data_management/absensi/absensi.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/add_permission/addProduct.dart';
import 'package:absensi/features/authentication/screens/data_management/izin/izin.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/edit_userdata/edit_userData.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/user_data/userData.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/addProduct.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/create_addproduct/create_addProduct.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/edit_addProduct.dart';
import 'package:absensi/features/authentication/screens/home/login/login.dart';
import 'package:absensi/features/authentication/screens/media/media.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/dashboard.dart';
import 'package:absensi/features/authentication/screens/home/forget_password/forget_password.dart';
import 'package:absensi/features/authentication/screens/home/register/register.dart';
import 'package:absensi/features/authentication/screens/home/reset_password/reset_password.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/allProduct.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/borrowed.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/create_borrowed/create_borrowed.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/edit_borrowed/edit_borrowed.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/returned.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/create_returned/create_returned.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/editreturned/edit_returned.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/inStock.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/create_instock/create_inStock.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/edit_inStock.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/create_outstock/create_outStock.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/edit_outstock/edit_outStock.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/AddoutStock.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/routes/routes_middleware.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class TAppRoute{
  static final List<GetPage> pages =[
    GetPage(name: TRoutes.login, page:()=> const LoginScrenn()),
    GetPage(name: TRoutes.register, page:()=> const RegisterScreen()),
    GetPage(name: TRoutes.forgetPassword, page:()=> const ForgetPasswordScreen()),
    GetPage(name: TRoutes.resetPassword, page:()=> const ResetPasswordScreen()),
    GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen()), 
    GetPage(name: TRoutes.media, page: () => const MediaScreen()), 


    //add product
    GetPage(name: TRoutes.addProduct, page: () => const AddProductScreen()),
    GetPage(name: TRoutes.createAddProduct, page: () => const CreateAddProductScreen()),
    GetPage(name: TRoutes.editAddProduct, page: () => const EditAddProductScreen()),
        
    //allProduct
    GetPage(name: TRoutes.allProduct, page: () => const AllProductScreen()),

    //stock
    GetPage(name: TRoutes.inStock, page: () => const InStockScreen()),
    GetPage(name: TRoutes.createinStock, page: () => const CreateInstock()),
    GetPage(name: TRoutes.editinStock, page: () => const EditInStockScreen()),

    GetPage(name: TRoutes.outStock, page: () => const AddOutStockScreen()),
    GetPage(name: TRoutes.createoutStock, page: () => const CreateOutstock()),
    GetPage(name: TRoutes.editoutStock, page: () => const EditOutStockScreen()),

    //Product
    GetPage(name: TRoutes.borrowedProduct, page: () => const AddBorrowedProductScreen()),
    GetPage(name: TRoutes.createborrowedProduct, page: () => const CreateBorrowedProductScreen()),
    GetPage(name: TRoutes.editborrowedProduct, page: () => const EditBorrowedProductScreen()),

    GetPage(name: TRoutes.returnedProduct, page: () => const AddReturnedProductScreen()),
    GetPage(name: TRoutes.createreturnedProduct, page: () => const CreateReturnedProductScreen()),
    GetPage(name: TRoutes.editreturnedProduct, page: () => const EditReturneddProductScreen()),



    //absensi
    GetPage(name: TRoutes.absensi, page: () => const AbsensiScreen()),
    GetPage(name: TRoutes.izin, page: () => const IzinScreen()),
    GetPage(name: TRoutes.addPermission, page: () => const AddPermissionScreen()),

    GetPage(name: TRoutes.userData, page: () => const UserDataScreen()),
    GetPage(name: TRoutes.editData, page: () => const EditUserDataScreen()),


 

 

  ];
}