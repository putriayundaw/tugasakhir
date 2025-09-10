import 'package:absensi/features/authentication/models/image_model.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';
import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/media/controllers/media_controller.dart';
import 'package:absensi/features/authentication/media/widgets/folder_dropdown.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
      () => controller.showImagesUploaderSection.value
          ? Column(
              children: [
                //drag and drop
                TRoundedContainer(
                  height: 250,
                  showBorder: true,
                  borderColor: TColors.borderPrimary,
                  backgroundColor: TColors.primaryBackground,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            //dropzone
                            // Drop Zone
                            DropzoneView(
                              mime: const ['image/jpeg', 'image/png'],
                              cursor: CursorType.Default,
                              operation: DragOperation.copy,
                              onLoaded: () => print('Zone loaded'),
                              onError: (ev) => print('Zone error: $ev'),
                              onHover: () => print('Zone hovered'),
                              onLeave: () => print('Zone left'),
                              onCreated: (ctrl) =>
                                  controller.dropzoneController = ctrl,
                              onDropInvalid: (ev) =>
                                  print('Zone invalid MIME: $ev'),
                              onDropFiles: (files) async {
                                files?.forEach((file) async {
                                  // Memanggil forEach hanya jika files tidak null
                                  if (file is DropzoneFileInterface) {
                                    final bytes = await controller
                                        .dropzoneController
                                        .getFileData(file);
                                    final image = ImageModel(
                                      url: '',
                                      file:
                                          file, // Menggunakan DropzoneFileInterface
                                      folder: '',
                                      filename: file.name,
                                      localImageToDisplay:
                                          Uint8List.fromList(bytes),
                                    );
                                    controller.selectedImagesToUpload
                                        .add(image);
                                  } else {
                                    print(
                                        'Unknown file type: ${file.runtimeType}');
                                  }
                                });
                                if (files == null) {
                                  print('No files dropped');
                                }
                              },
                            ),

                            ///frop zone
                            Column(
                              children: [
                                Image.asset(TImages.defaultMultiImageIcon,
                                    width: 50, height: 50),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                const Text('Drag and Drop Images here'),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('Select Images')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                ///heading   & localy selected image

                if (controller.selectedImagesToUpload.isNotEmpty)
                  TRoundedContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              //folders dropdown
                              children: [
                                Text('Select Folder',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                MediaFolderDropdown(
                                  onChanged: (MediaCategory? newValue) {
                                    if (newValue != null) {
                                      controller.selectedPath.value = newValue;
                                    }
                                  },
                                ),
                              ],
                            ),
                            //upload remove button
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () => controller.selectedImagesToUpload.clear(),
                                    child: const Text('Remove All')),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                TDeviceUtils.isMobileScreen(context)
                                    ? const SizedBox.shrink()
                                    : SizedBox(
                                        width: TSizes.buttonWidth,
                                        child: ElevatedButton(
                                            onPressed: () => controller.uploadImagesConfirmation(),
                                            child: const Text('Upload'))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: TSizes.spaceBtwItems / 2,
                          runSpacing: TSizes.spaceBtwItems / 2,
                          children: controller.selectedImagesToUpload
                              .where(
                                  (image) => image.localImageToDisplay != null)
                              .map((element) => TRoundedImage(
                                    width: 90,
                                    height: 90,
                                    padding: TSizes.sm,
                                    imageType: ImageType.memory,
                                    memoryImage: element.localImageToDisplay,
                                    backgroundColor: TColors.primaryBackground,
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        ///upload butttom
                        TDeviceUtils.isMobileScreen(context)
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => controller.uploadImagesConfirmation(),
                                    child: const Text('Upload')))
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
