import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/izin_controller.dart';
import 'package:absensi/features/authentication/controller/AttendanceManagement/minio_controller.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class AddPermissionForm extends StatefulWidget {
  const AddPermissionForm({super.key});

  @override
  State<AddPermissionForm> createState() => _AddPermissionFormState();
}

class _AddPermissionFormState extends State<AddPermissionForm> {
  final _formKey = GlobalKey<FormState>();
  final MinioService _minioService = MinioService();

  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _schoolC = TextEditingController();
  final TextEditingController _infoC = TextEditingController();

  final List<String> _days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  String? _selectedDay;
  DateTime? _selectedDate;

  DropzoneViewController? _dzController;
  final List<_PickedImage> _images = [];
  bool _isUploading = false;

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _openFilePickerAndAdd() async {
    try {
      final input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.multiple = true;

      final completer = Completer<List<html.File>?>();

      input.onChange.listen((_) {
        final files = input.files;
        completer.complete(files?.toList() ?? []);
      });

      input.click();

      final files = await completer.future;
      if (files == null || files.isEmpty) return;

      for (final file in files) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          final result = reader.result;
          if (result is ByteBuffer) {
            setState(() {
              _images.add(_PickedImage(
                filename: file.name,
                bytes: Uint8List.view(result),
              ));
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  void _removeImageAt(int idx) {
    setState(() {
      _images.removeAt(idx);
    });
  }

  Future<List<String>> _uploadImagesToMinIO() async {
    if (_images.isEmpty) return [];

    setState(() {
      _isUploading = true;
    });

    try {
      await _minioService.initialize();

      List<Uint8List> imagesBytes = [];
      List<String> fileNames = [];

      for (final image in _images) {
        imagesBytes.add(image.bytes);
        fileNames.add(image.filename);
      }

      final uploadedImageUrls = await _minioService.uploadMultipleFiles(imagesBytes, fileNames);

      return uploadedImageUrls;
    } catch (e) {
      debugPrint('Error uploading to MinIO: $e');
      Get.snackbar('Error', 'Gagal mengupload gambar ke MinIO: $e');
      return [];
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<File> _createTempFile(Uint8List bytes, String filename) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/$filename');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  void _onCreatePressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      Get.snackbar('Error', 'Harap isi semua field yang diperlukan');
      return;
    }

    if (_selectedDay == null) {
      Get.snackbar('Error', 'Pilih hari terlebih dahulu');
      return;
    }

    if (_selectedDate == null) {
      Get.snackbar('Error', 'Pilih tanggal terlebih dahulu');
      return;
    }

    if (_images.isEmpty) {
      Get.rawSnackbar(
        message: 'Harap unggah minimal 1 foto',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      final izinController = Get.find<IzinController>();

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false
      );

      List<String> imageUrls = [];
      if (_images.isNotEmpty) {
        imageUrls = await _uploadImagesToMinIO();
        if (imageUrls.isEmpty && _images.isNotEmpty) {
          Get.back(); 
          Get.snackbar('Error', 'Gagal mengupload gambar');
          return;
        }
      }

      final success = await izinController.createPermission(
        name: _nameC.text.trim(),
        school: _schoolC.text.trim(),
        day: _selectedDay!,
        date: _formatDate(_selectedDate!),
        information: _infoC.text.trim(),
        images: imageUrls.map((url) {
          try {
            final uri = Uri.parse(url);
            return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : url;
          } catch (_) {
            return url;
          }
        }).toList(),
      );

      Get.back(); 
      if (success) {
        await izinController.fetchPermissions();
        Get.snackbar(
          'Sukses',
          'Permission berhasil dibuat',
          backgroundColor: Colors.green,
          colorText: Colors.white
        );

        await Future.delayed(const Duration(seconds: 1));

        if (Get.isDialogOpen!) Get.back();
        Get.offNamed('/permission');
      } else {
        Get.snackbar(
          'Error', 
          'Gagal membuat permission',
          backgroundColor: Colors.red, 
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.back(); 
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red, 
        colorText: Colors.white
      );
    }
  }


  @override
  void dispose() {
    _nameC.dispose();
    _schoolC.dispose();
    _infoC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 900;

    final leftColumn = TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Permission',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            TextFormField(
              controller: _nameC,
              validator: (v) => TValidator.validateEmptyText('Name', v),
              decoration:
                  const InputDecoration(labelText: 'Name', prefixIcon: Icon(Iconsax.user)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: _schoolC,
              validator: (v) => TValidator.validateEmptyText('School', v),
              decoration:
                  const InputDecoration(labelText: 'School', prefixIcon: Icon(Iconsax.home)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            DropdownButtonFormField<String>(
              value: _selectedDay,
              decoration:
                  const InputDecoration(labelText: 'Day', prefixIcon: Icon(Iconsax.calendar)),
              items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _selectedDay = v),
              validator: (v) => (v == null || v.isEmpty) ? 'Choose a day' : null,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            InkWell(
              onTap: () async {
                final now = DateTime.now();
                final pick = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? now,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5));
                if (pick != null) setState(() => _selectedDate = pick);
              },
              child: IgnorePointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: const Icon(Iconsax.calendar_tick),
                    hintText:
                        _selectedDate != null ? _formatDate(_selectedDate!) : 'Choose a date',
                  ),
                  validator: (v) => _selectedDate == null ? 'Choose a date' : null,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            TextFormField(
              controller: _infoC,
              validator: (v) => TValidator.validateEmptyText('Information', v),
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                  labelText: 'Information', alignLabelWithHint: true, prefixIcon: Icon(Iconsax.info_circle)),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _onCreatePressed, child: const Text('Create'))),
              ],
            ),
          ],
        ),
      ),
    );

    final rightColumn = TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Photos', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                DropzoneView(
                  mime: const ['image/jpeg', 'image/png', 'image/webp'],
                  operation: DragOperation.copy,
                  cursor: CursorType.Default,
                  onCreated: (ctrl) => _dzController = ctrl,
                  onLoaded: () => print('Dropzone loaded'),
                  onError: (e) => print('Dropzone error: $e'),
                  onDropFiles: (files) async {
                    if (files == null) return;
                    for (final file in files) {
                      try {
                        final bytes = await _dzController!.getFileData(file);
                        setState(() {
                          _images.add(_PickedImage(
                            filename: file.name ?? 'image',
                            bytes: Uint8List.fromList(bytes),
                          ));
                        });
                      } catch (e) {
                        print('Gagal getFileData: $e');
                      }
                    }
                  },
                ),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(TImages.defaultMultiImageIcon, width: 48, height: 48),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const Text('Drag and Drop Images here'),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      OutlinedButton(onPressed: _openFilePickerAndAdd, child: const Text('Select Images')),
                      if (_images.isNotEmpty) ...[
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Text(
                          '${_images.length} gambar terpilih',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            ),
            child: Row(
              children: [
                Icon(Icons.cloud_upload, color: Colors.blue.shade600, size: 16),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: Text(
                    'Gambar akan disimpan di MinIO Cloud Storage',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TSizes.spaceBtwItems),

          if (_images.isNotEmpty) ...[
            Text(
              'Preview Gambar:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            
          Wrap(
            spacing: TSizes.spaceBtwItems / 2,
            runSpacing: TSizes.spaceBtwItems / 2,
            children: List.generate(_images.length, (i) {
              final img = _images[i];
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  TRoundedImage(
                    width: 110,
                    height: 110,
                    padding: TSizes.sm,
                    imageType: ImageType.memory,
                    memoryImage: img.bytes,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _removeImageAt(i),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
        ],
      ),
    );

    return isNarrow
        ? Column(children: [leftColumn, const SizedBox(height: TSizes.spaceBtwSections), rightColumn])
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 6, child: leftColumn), const SizedBox(width: TSizes.spaceBtwSections), Expanded(flex: 4, child: rightColumn)]);
  }
}

class _PickedImage {
  final String filename;
  final Uint8List bytes;

  _PickedImage({required this.filename, required this.bytes});
}
