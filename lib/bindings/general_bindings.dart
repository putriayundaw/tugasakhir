import 'package:absensi/features/authentication/controller/user_controller.dart';
import 'package:absensi/utils/helpers/network_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class GeneralBindings extends Bindings{

  @override 
  void dependencies(){
    //core 
    Get.lazyPut(() => NetworkManager(), fenix: true);
        Get.lazyPut(() => UserController(), fenix: true);

  }
  
}