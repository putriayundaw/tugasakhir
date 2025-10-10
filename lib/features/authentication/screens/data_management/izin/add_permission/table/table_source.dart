import 'package:absensi/features/authentication/screens/data_management/izin/Models/permission_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PermissionRows extends DataTableSource {
  final List<PermissionModel> permissions;

  PermissionRows({required this.permissions});

  @override
  DataRow? getRow(int index) {
    if (index >= permissions.length) return null;
    final p = permissions[index];

    final String dateStr = (p.date != null)
        ? DateFormat('yyyy-MM-dd').format(p.date!)
        : '';

    final String dayDate = (p.day.isNotEmpty)
        ? '${p.day}${dateStr.isNotEmpty ? ' / $dateStr' : ''}'
        : (dateStr.isNotEmpty ? dateStr : 'No date');

    String infoShort = p.information;
    if (infoShort.length > 30) infoShort = '${infoShort.substring(0, 27)}...';

    return DataRow(
      cells: [
        DataCell(_buildTextCell(p.name)),
        DataCell(_buildTextCell(p.school)),
        DataCell(_buildTextCell(dayDate)),
        DataCell(
          Tooltip(
            message: p.information,
            child: _buildTextCell(infoShort),
          ),
        ),
        DataCell(_buildImageCell(p)),
      ],
    );
  }

  Widget _buildTextCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text.isNotEmpty ? text : '-'),
    );
  }

  Widget _buildImageCell(PermissionModel permission) {
    final String imageUrl = (permission.images.isNotEmpty && permission.images.first.isNotEmpty)
        ? permission.images.first
        : '';

    if (imageUrl.isEmpty) {
      return _buildPlaceholder(
        Icons.image_not_supported, 
        'Tidak ada gambar',
        Colors.grey
      );
    }

    if (!_isValidMinIOUrl(imageUrl)) {
      return _buildPlaceholder(
        Icons.warning, 
        'URL tidak valid',
        Colors.orange,
        tooltip: 'URL: $imageUrl'
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) => 
                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
            errorWidget: (context, url, error) {
              print('Error loading image: $error');
              print('URL: $url');
              
              return _buildPlaceholder(
                Icons.error, 
                'Gagal memuat',
                Colors.red,
                tooltip: 'Error: $error\nURL: $url'
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon, String text, Color color, {String? tooltip}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Tooltip(
        message: tooltip ?? text,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(fontSize: 8, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidMinIOUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && 
             uri.host.isNotEmpty &&
             uri.scheme.startsWith('http') &&
             uri.path.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override bool get isRowCountApproximate => false;
  @override int get rowCount => permissions.length;
  @override int get selectedRowCount => 0;
}