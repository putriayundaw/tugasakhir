class TRoutes{
  static const login ='/login';
  
  static const register ='/register';

  static const forgetPassword ='/forget-password/';

  static const resetPassword = '/reset-password';

  static const dashboard ='/dashboard';

  static const media ='/media';


  static const addProduct ='/add-Product';
  static const createAddProduct='/create-AddProduct';
  static const editAddProduct ='/edit-AddProduct';

  static const allProduct ='/all-Product';

  static const inStock ='/in-Stock';
  static const createinStock='/Add-inStock';
  static const editinStock ='/edit-InStock';

  static const outStock ='/out-Stock';
  static const createoutStock='/create-outstock';
  static const editoutStock ='/edit-outstock';

  static const absensi ='/attendance';
  static const izin ='/permission';
  static const addPermission ='/add-permission';

  static const userData = '/user-data';
  static const editData = '/edit-userData';


  static const borrowedProduct ='/history-borrowed-product';
  static const createborrowedProduct='/create-borrowed-product';
  static const editborrowedProduct ='/edit-borrowed-product';

  static const returnedProduct ='/history-returned-product';
  static const createreturnedProduct='/create-returned-product';
  static const editreturnedProduct ='/edit-returned-product';


  static List sidebarMenuItems =[
    dashboard,
    media,
    addProduct,
    allProduct,
    inStock,
    outStock,
    absensi,
    borrowedProduct,
    returnedProduct,
    absensi,
    userData,
   
    
  ];
}