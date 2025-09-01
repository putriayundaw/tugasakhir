import 'package:absensi/data/models/user_model.dart';
import 'package:absensi/data/repositories/authentication/authentication_repository.dart';
import 'package:absensi/data/repositories/user/user_repository.dart';
import 'package:absensi/features/authentication/controller/user_controller.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:absensi/utils/helpers/network_manager.dart';
import 'package:absensi/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController{
  static LoginController get instance =>Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormkey = GlobalKey<FormState>();

    @override 
    void onInit(){
      email.text = localStorage.read('REMEMBER_ME_EMAIL')?? '';
      password.text = localStorage.read('REMEMBER_ME_PASSWORD')?? '';
    
      super.onInit();
    }



  //handle email and passsword sign in process
  Future<void> emailAndPasswordSignIn() async{
    try{
      //start loading
      TFullScreenLoader.openLoadingDialog('Logging you in..', TImages.docerAnimation);

      //check interner
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      //form validation
      if(!loginFormkey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }
      //save data if remember is selected
      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }
      //login yser using email & password auth
      await AuthenticationRepository.instance.LoginWithEmailAndPassword(email.text.trim(),password.text.trim());

      //fetch user details and assign to usercontroller
      final user = await UserController.instance.fetchUserDetails();
      
      //remove loader
      TFullScreenLoader.stopLoading();

      //if user is not admin , loggout and return
      if(user.role != AppRole.admin){
        await AuthenticationRepository.instance.logout();
        TLoaders.errorSnackBar(title: 'Not Authorized', message: 'You are not authorized or do have access. Contac admin');
      }else{
        //redirect
        AuthenticationRepository.instance.screenRedirect();
      }

    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }

  //handle registration of admin user
  Future<void> registerAdmin() async{
    try{
 //start loading
        TFullScreenLoader.openLoadingDialog('Registering Admin Account...',TImages.docerAnimation);
    
    //check internet conectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if(!isConnected){
      TFullScreenLoader.stopLoading();
      return;
    }

    //register user using email & password authentication
    await AuthenticationRepository.instance.registerWithEmailAndPassword(TTexts.adminEmail, TTexts.adminPassword);

    //create admin recod in the firestore
    final userRepository = Get.put(UserRepository());
    await userRepository.createUser(
      UserModel(
        id:AuthenticationRepository.instance.authUser!.uid,
        name: 'otomasi',
        email: TTexts.adminEmail,
        role: AppRole.admin,
        createdAt: DateTime.now(),
      ),
    );
    //remove loader
    TFullScreenLoader.stopLoading();

    //redirect
    AuthenticationRepository.instance.screenRedirect();
    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
    }
  }
  