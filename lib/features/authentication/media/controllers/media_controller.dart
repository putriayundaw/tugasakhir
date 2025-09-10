
import 'dart:typed_data';

import 'package:absensi/features/authentication/models/image_model.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/popups/dialogs.dart';
import 'package:absensi/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart';

class MediaController extends GetxController{
  static MediaController get instance => Get.find();

  late DropzoneViewController dropzoneController;
  final RxBool showImagesUploaderSection = false.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;

  final RxList<ImageModel> allImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;
  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;
  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;
  final RxList<ImageModel> allUserImages = <ImageModel>[].obs;


  Future<void> selectedLocalImages() async{
    final files = await dropzoneController.pickFiles(multiple: true, mime: ['image/jpeg','image/png']);

    if(files.isNotEmpty){
      for (var file in files){
        if (file is html.File){
          final bytes = await dropzoneController.getFileData(file);
          final image = ImageModel(
            url: '',
            file: file,
            folder: '',
            filename: file.name,
            localImageToDisplay: Uint8List.fromList(bytes),
          );
          selectedImagesToUpload.add(image);
        }
      }
    }

  }
  void uploadImagesConfirmation(){
    if (selectedPath.value == MediaCategory.folders){
      TLoaders.warningSnackBar(title: 'Select Folder', message: 'Please selct the folder in order to upload the Images');
      return;
    }

    TDialogs.defaultDialog(
      context: Get.context!,
      title:'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async => await uploadImages(),
      content: 'Are you sure you want upload all the images in ${selectedPath.value.name.toUpperCase()} folder?',
    );
  }
  Future<void> uploadImages() async{
    try{
      //remove confirmation box
      Get.back();
      
      ///loader
      uploadImagesloader();

      //get the selected category
      MediaCategory selectedCategory = selectedPath.value;

      //getthe corresponding list to update
      RxList<ImageModel> targetlist;

    }catch(e){
      //stop loader in case of an error
      TFullScreenLoader.stopLoading();

      //show a warning snack bar for the error
      TLoaders.warningSnackBar(title: 'Error Uploading Images', message: 'Something went wrong while uploading your Images.');
    }
  }
  void uploadImagesloader(){
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context)=> PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Uploading Images'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(TImages.uploadingImageIllustration, height: 300,width: 300),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Sit Tight, Your images are uploading...'),
            ],
          ),
        ),
      )
    );
  }
}