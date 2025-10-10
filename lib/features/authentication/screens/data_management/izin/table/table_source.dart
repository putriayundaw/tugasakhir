import 'package:absensi/features/authentication/screens/data_management/izin/Models/permission_model.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PermissionRows extends DataTableSource {
  final List<PermissionModel> permissions;

  PermissionRows({required this.permissions});

  @override
  DataRow? getRow(int index) {
    if (index >= permissions.length) return null;
    final p = permissions[index];

    final String imageUrl = (p.images.isNotEmpty && p.images.first.isNotEmpty)
        ? p.images.first
        : '';
    final String dateStr =
        (p.date != null) ? DateFormat('yyyy-MM-dd').format(p.date!) : '';

    final String dayDate = (p.day.isNotEmpty)
        ? '${p.day}${dateStr.isNotEmpty ? ' / $dateStr' : ''}'
        : (dateStr.isNotEmpty ? dateStr : 'No date');

    String infoShort = p.information;
    if (infoShort.length > 60) infoShort = '${infoShort.substring(0, 57)}...';

    return DataRow2(
      cells: [
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(p.name.isNotEmpty ? p.name : '-'),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(p.school.isNotEmpty ? p.school : '-'),
          ),
        ),
       
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(dayDate),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(infoShort),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _buildImageCell(imageUrl),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCell(String imageUrl) {
    print('Raw imageUrl from database: $imageUrl');

    if (imageUrl.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: TColors.primaryBackground,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade400,
          size: 24,
        ),
      );
    }

    String finalImageUrl = imageUrl;
    if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
      finalImageUrl = 'http://192.168.100.160:9000/ocn/foto_izin%2F$imageUrl';
      print('Constructed full URL: $finalImageUrl');
    }

    if (!_isValidUrl(finalImageUrl)) {
      print('Invalid URL: $finalImageUrl');
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: TColors.primaryBackground,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade400,
          size: 24,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: finalImageUrl,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: TColors.primaryBackground,
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
        ),
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) {
        print('Error loading image from MinIO: $error');
        print('URL: $url');

        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: Tooltip(
            message: 'Gagal memuat gambar\nURL: $url\nError: $error',
            child: Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => permissions.length;

  @override
  int get selectedRowCount => 0;
}
