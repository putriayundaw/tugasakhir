import 'package:absensi/data/models/user_model.dart';
import 'package:absensi/data/repositories/authentication/authentication_repository.dart';
import 'package:absensi/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:absensi/utils/exceptions/format_exceptions.dart';
import 'package:absensi/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  ///function save user data to firestore
  Future<void> createUser(UserModel user) async {
    try {
      final userDoc = await _db.collection('Users').doc(user.id).get();

      // Cek apakah user sudah ada
      if (userDoc.exists) {
        print('User with ID ${user.id} already exists. Skipping creation.');
        return;
      }

      // Jika belum ada, simpan user baru
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  ///fetch user details based o user id
  Future<UserModel> fetchAdminDetails() async {
    try {
      final docSnapshot = await _db
          .collection('Users')
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();

      return UserModel.fromSnapshot(docSnapshot);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong: $e';
    }
  }
}
