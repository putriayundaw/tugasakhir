
import 'package:absensi/features/authentication/controller/home/login_controller.dart';
import 'package:absensi/features/authentication/controller/home/user_controller.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/izin_controller.dart';
import 'package:absensi/features/authentication/screens/data_management/user_data/services/user_service.dart';
import 'package:absensi/utils/helpers/network_manager.dart';
import 'package:absensi/features/authentication/controller/home/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class GeneralBindings extends Bindings{

  @override 
  void dependencies(){
    //core 
    Get.lazyPut(() => NetworkManager(), fenix: true);
     Get.put(LoginController(), permanent: true);
    Get.put(UserService(), permanent: true);
    Get.lazyPut(() => IzinController(), fenix: true);
    Get.lazyPut(() => UserService(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);

  }
  
}
