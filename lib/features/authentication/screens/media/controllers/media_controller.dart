// Import untuk dart:io jika diperlukan
import 'dart:typed_data';

import 'package:absensi/data/repositories/media/media_repository.dart';
import 'package:absensi/features/authentication/screens/media/models/image_model.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/constans/text_strings.dart';
import 'package:absensi/utils/popups/dialogs.dart';
import 'package:absensi/utils/popups/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:universal_html/html.dart' as html;

class MediaController extends GetxController {
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

  final MediaRepository mediaRepository = MediaRepository();

  Future<void> selectedLocalImages() async {
    final files = await dropzoneController.pickFiles(multiple: true, mime: ['image/jpeg', 'image/png']);

    if (files.isNotEmpty) {
      for (var file in files) {
        if (file is html.File) {
          final bytes = await dropzoneController.getFileData(file);

          // Menambahkan file ke selectedImagesToUpload
          final image = ImageModel(
            url: '',
            file: file, // Menggunakan html.File untuk web
            folder: '',
            filename: file.name,
            localImageToDisplay: Uint8List.fromList(bytes),
          );
          selectedImagesToUpload.add(image);
        }
      }
    }
  }

  void uploadImagesConfirmation() {
    if (selectedPath.value == MediaCategory.folders) {
      TLoaders.warningSnackBar(title: 'Select Folder', message: 'Please select the folder in order to upload the images');
      return;
    }

    TDialogs.defaultDialog(
      context: Get.context!,
      title: 'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async => await uploadImages(),
      content: 'Are you sure you want to upload all the images in the ${selectedPath.value.name.toUpperCase()} folder?',
    );
  }

  Future<void> uploadImages() async {
    try {
      // Remove confirmation box
      Get.back();

      // Loader
      uploadImagesloader();

      // Get the selected category
      MediaCategory selectedCategory = selectedPath.value;

      // Get the corresponding list to update
      RxList<ImageModel> targetList;

      // Check the selected category and update the corresponding list
      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }

      // Upload and add images to the target list
      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesToUpload[i];
        final file = selectedImage.file;

        // Pastikan file adalah html.File untuk platform web
        if (file is html.File) {
          // Menggunakan html.File langsung untuk platform web
          final uploadedImage = await mediaRepository.uploadImageFileInStorage(
            file: file,  // Menggunakan html.File
            path: getSelectedPath(),
            imageName: selectedImage.filename,
          );

          // Upload image to Firestore
          uploadedImage.mediaCategory = selectedCategory.name;
          final id = await mediaRepository.uploadImageFileInDatabase(uploadedImage);

          uploadedImage.id = id;

          selectedImagesToUpload.removeAt(i);
          targetList.add(uploadedImage);
        } else {
          // Menangani jika file bukan html.File (misalnya untuk platform mobile)
          print('Unsupported file type');
        }
      }

      // Stop loader after success
      TFullScreenLoader.stopLoading();
    } catch (e) {
      // Stop loader in case of an error
      TFullScreenLoader.stopLoading();

      // Show a warning snack bar for the error
      TLoaders.warningSnackBar(title: 'Error Uploading Images', message: 'Something went wrong while uploading your images.');
    }
  }

  void uploadImagesloader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Uploading Images'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(TImages.uploadingImageIllustration, height: 300, width: 300),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Sit Tight, Your images are uploading...'),
            ],
          ),
        ),
      ),
    );
  }

  String getSelectedPath() {
    String path = '';
    switch (selectedPath.value) {
      case MediaCategory.banners:
        path = TTexts.bannersStoragePath;
        break;
      case MediaCategory.brands:
        path = TTexts.brandsStoragePath;
        break;
      case MediaCategory.categories:
        path = TTexts.categoriesStoragePath;
        break;
      case MediaCategory.products:
        path = TTexts.productsStoragePath;
        break;
      case MediaCategory.users:
        path = TTexts.usersStoragePath;
        break;
      default:
        path = 'others';
        break;
    }
    return path;
  }
}
