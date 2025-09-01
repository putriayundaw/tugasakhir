import 'package:absensi/data/models/user_model.dart';
import 'package:absensi/data/repositories/user/user_repository.dart';
import 'package:absensi/utils/popups/loaders.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());


  Future<UserModel> fetchUserDetails() async{
    try{
      final user = await userRepository.fetchAdminDetails();
      return user;
    }catch (e){
      TLoaders.errorSnackBar(title: 'Something went wrong.',message: e.toString());
       return UserModel .empty();
    }
  }
}