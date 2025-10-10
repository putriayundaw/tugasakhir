import 'dart:io';
import 'package:absensi/features/authentication/screens/media/models/image_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html; // Untuk browser/web

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  // Firebase Storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image using file
  Future<ImageModel> uploadImageFileInStorage({
    required html.File file, 
    required String path, 
    required String imageName
  }) async {
    try {
      // Reference to the storage location
      final Reference ref = _storage.ref('$path/$imageName');

      // Upload the file
      await ref.putBlob(file);  // Note: Ensure that you are using the correct method to upload

      // Get the download URL
      final String downloadURL = await ref.getDownloadURL();

      // Get file metadata
      final FullMetadata metadata = await ref.getMetadata();

      // Return ImageModel from metadata and download URL
      return ImageModel.fromFirebaseMetadata(metadata, path, imageName, downloadURL);
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance.collection("Images").add(image.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
