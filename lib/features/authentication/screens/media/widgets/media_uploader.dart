import 'dart:async';
import 'dart:typed_data';

import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/screens/media/controllers/media_controller.dart';
import 'package:absensi/features/authentication/screens/media/models/image_model.dart';
import 'package:absensi/features/authentication/screens/media/widgets/folder_dropdown.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/device/device_utility.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;

    // Helper: baca html.File jadi Uint8List (untuk fallback web)
    Future<Uint8List?> _readHtmlFileAsBytes(html.File file) {
      final completer = Completer<Uint8List?>();
      try {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          try {
            final result = reader.result;
            if (result is ByteBuffer) {
              completer.complete(Uint8List.view(result));
            } else if (result is List) {
              // Kadang result bisa berupa List<int>
              completer.complete(Uint8List.fromList(List<int>.from(result)));
            } else {
              completer.complete(null);
            }
          } catch (e) {
            completer.completeError(e);
          }
        });
        reader.onError.listen((ev) {
          completer.completeError(ev);
        });
      } catch (e) {
        completer.completeError(e);
      }
      return completer.future;
    }

    // Main helper: buka file picker (coba dropzone.pickFiles, lalu fallback ke input element)
    Future<void> _openFilePickerAndAdd() async {
      try {
        final dz = controller.dropzoneController;

        // Jika ada dropzone controller, coba gunakan pickFiles()
        if (dz != null) {
          try {
            // beberapa versi flutter_dropzone menerima argumen, beberapa tidak.
            List<dynamic>? picked;
            try {
              // coba dengan MIME dan multiple
              picked = await dz.pickFiles(mime: ['image/jpeg', 'image/png'], multiple: true);
            } catch (_) {
              // fallback tanpa argumen
              picked = await dz.pickFiles();
            }

            if (picked != null && picked.isNotEmpty) {
              for (final file in picked) {
                try {
                  // ambil data binary menggunakan metode yang sama seperti onDropFiles
                  final bytes = await dz.getFileData(file);
                  // filename: coba ambil .name property
                  String filename = 'unknown';
                  try {
                    filename = (file.name ?? (file as dynamic).name ?? 'unknown').toString();
                  } catch (_) {
                    filename = 'unknown';
                  }

                  final image = ImageModel(
                    url: '',
                    file: file, // DropzoneFileInterface
                    folder: '',
                    filename: filename,
                    localImageToDisplay: Uint8List.fromList(bytes),
                  );

                  controller.selectedImagesToUpload.add(image);
                } catch (e) {
                  // jangan crash, lanjutkan file lain
                  print('Gagal memproses file dari dropzone.pickFiles(): $e');
                }
              }
              return;
            }
          } catch (e) {
            print('dropzone.pickFiles() error: $e — lanjut ke fallback html input');
            // lanjut ke fallback di bawah
          }
        }

        // Fallback web: gunakan html input element
        final input = html.FileUploadInputElement();
        input.accept = 'image/*';
        input.multiple = true;

        // tambahkan listener perubahan
        final completer = Completer<List<html.File>?>();

        input.onChange.listen((event) {
          final files = input.files;
          if (files == null || files.isEmpty) {
            completer.complete(<html.File>[]);
          } else {
            completer.complete(files);
          }
        });

        input.click();

        final files = await completer.future;
        if (files == null || files.isEmpty) {
          print('Tidak ada file dipilih (fallback).');
          return;
        }

        for (final file in files) {
          try {
            final bytes = await _readHtmlFileAsBytes(file);
            if (bytes == null) {
              print('Gagal membaca file ${file.name}');
              continue;
            }

            final image = ImageModel(
              url: '',
              file: file, // html.File
              folder: '',
              filename: file.name,
              localImageToDisplay: bytes,
            );

            controller.selectedImagesToUpload.add(image);
          } catch (e) {
            print('Gagal memproses html.File: $e');
          }
        }
      } catch (e) {
        print('Error membuka file picker: $e');
      }
    }

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

                            ///drop zone UI
                            Column(
                              children: [
                                Image.asset(TImages.defaultMultiImageIcon,
                                    width: 50, height: 50),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                const Text('Drag and Drop Images here'),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                // --- Panggil helper _openFilePickerAndAdd saat tombol ditekan ---
                                OutlinedButton(
                                    onPressed: () => _openFilePickerAndAdd(),
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