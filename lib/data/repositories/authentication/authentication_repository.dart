
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:absensi/utils/exceptions/firebase_exceptions.dart';
import 'package:absensi/utils/exceptions/format_exceptions.dart';
import 'package:absensi/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  //firebase auth instance
  final _auth = FirebaseAuth.instance;

  //get autenticated user data
  User? get authUser => _auth.currentUser;

  //get is authenticated user
  bool get isAuthenticated => _auth.currentUser != null;

  @override 
  void onReady(){
    _auth.setPersistence(Persistence.LOCAL);
  }

  // function to derermine the rlevant creen and dredirect accorgingly
  void screenRedirect()async{
    final user =_auth.currentUser;
    
    //if the user is logged in
    if (user != null){
      //navigate to the  home
      Get.offAllNamed(TRoutes.dashboard);
    }else{
      Get.offAllNamed(TRoutes.login);
    }
  }
  //login 
  Future<UserCredential> LoginWithEmailAndPassword(String email, String password) async {
  try {

    return _auth.signInWithEmailAndPassword(email: email, password: password);
    // logika login
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException();
  } on PlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

//register
Future<UserCredential> registerWithEmailAndPassword(String email, String password) async{
    try {

    return _auth.createUserWithEmailAndPassword(email: email, password: password);
    // logika login
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException();
  } on PlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}
//logout
Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(TRoutes.login);
  } on FirebaseAuthException catch (e) {
    throw TFirebaseAuthException(e.code).message;
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } on FormatException catch (_) {
    throw const TFormatException();
  } on PlatformException catch (e) {
    throw TPlatformException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again';
  }
}

}
