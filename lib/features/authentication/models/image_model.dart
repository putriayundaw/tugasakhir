import 'dart:typed_data';

import 'package:absensi/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ImageModel {
  String id;
  final String url;
  final Object? file;  // Menggunakan Object untuk menampung berbagai tipe (html.File atau DropzoneFileInterface)
  final String folder;
  final int? sizeBytes;  // Nullable
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;  // Nullable
  RxBool isSelected = false.obs;
  final Uint8List? localImageToDisplay;

  ImageModel({
    this.id = '',
    this.file,  // Menyimpan file yang bisa berupa DropzoneFileInterface atau html.File
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  static ImageModel empty() => ImageModel(url: '', folder: '', filename: '');

  String get createdAtFormatted => TFormatter.formatDate(createdAt);
  String get updatedAtFormatted => TFormatter.formatDate(updatedAt);

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes ?? 0,
      'filename': filename,
      'fullPath': fullPath,
      'createdAt': createdAt?.toUtc(),
      'contentType': contentType ?? '',
      'mediaCategory': mediaCategory,
    };
  }

  factory ImageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ImageModel(
        id: document.id,
        url: data['url'] ?? '',
        folder: data['folder'] ?? '',
        sizeBytes: data['sizeBytes'] ?? 0,
        filename: data['filename'] ?? '',
        fullPath: data['fullPath'] ?? '',
        createdAt: data.containsKey('createdAt') ? data['createdAt']?.toDate() : null,
        updatedAt: data.containsKey('updatedAt') ? data['updatedAt']?.toDate() : null,
        contentType: data['contentType'] ?? '',
        mediaCategory: data['mediaCategory'] ?? '',
      );
    } else {
      return ImageModel.empty();
    }
  }

  factory ImageModel.fromFirebaseMetadata(
      FullMetadata metadata, String folder, String filename, String downloadURL) {
    return ImageModel(
      url: downloadURL,
      folder: folder,
      filename: filename,
      sizeBytes: metadata.size,
      updatedAt: metadata.updated,
      fullPath: metadata.fullPath,
      createdAt: metadata.timeCreated,
      contentType: metadata.contentType,
    );
  }
}
