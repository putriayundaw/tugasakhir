// table_source.dart
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';


class AllProductsRows extends DataTableSource {
  List<AllProductModel> products;

  AllProductsRows({required this.products});
   Widget _buildProductImage(String imageUrl) {
    String finalImageUrl = imageUrl;
    
 
    if (imageUrl.isEmpty) {
      return TRoundedImage(
        width: 50,
        height: 50,
        padding: TSizes.sm,
        image: TImages.defaultImage,
        imageType: ImageType.asset,
        borderRadius: TSizes.borderRadiusMd,
        backgroundColor: TColors.primaryBackground,
      );
    }

    // Use imageUrl as is if it already contains full URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      finalImageUrl = imageUrl;
    } else {
      
      finalImageUrl = 'http://192.168.100.160:9001/ocn/produk/$imageUrl';
      print('Constructed full URL: $finalImageUrl');
    }

    // // Validasi URL
    // if (!_isValidUrl(finalImageUrl)) {
    //   print('Invalid URL: $finalImageUrl');
    //   return Container(
    //     width: 50,
    //     height: 50,
    //     decoration: BoxDecoration(
    //       color: TColors.primaryBackground,
    //       borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
    //       border: Border.all(color: Colors.grey.shade300),
    //     ),
    //     child: Icon(
    //       Icons.image_not_supported,
    //       color: Colors.grey.shade400,
    //       size: 24,
    //     ),
    //   );
    // }

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
            message: 'Gagal memuat gambar\URL: $url\nError: $error',
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
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }


  @override
  DataRow? getRow(int index) {
    final product = products[index];

    return DataRow2(
      cells: [
  DataCell(
          _buildProductImage(product.imageUrl),
        ),
        DataCell(Text(product.name)),
        DataCell(Text('${product.price}')),
        DataCell(Text('${product.stock}')),
        DataCell(Text(product.borrowed)),
        DataCell(Text(product.returned)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
