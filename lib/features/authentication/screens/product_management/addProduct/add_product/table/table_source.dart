import 'package:absensi/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/controller/productManagement/addproduct_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/edit_addproduct/widgets/edit_Addproduct_form.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddProductsRows extends DataTableSource {
  final List<ProductModel> products;

  AddProductsRows({required this.products});

  // Method untuk build product image
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
      
      finalImageUrl = 'http://192.168.100.160:9000/ocn/produk/$imageUrl';
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

  // Method untuk show delete confirmation
  void _showDeleteDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final ProductsController controller = ProductsController.instance;
              await controller.deleteProduct(
                productId: product.id,
                context: context,
              );
              // Reload products setelah delete
              controller.loadProducts();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    
    final product = products[index];

    return DataRow2(
      cells: [
        // Image cell
        DataCell(
          _buildProductImage(product.imageUrl),
        ),
        
        // Name cell
        DataCell(
          Text(
            product.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        
        // Price cell
        DataCell(Text(product.price)),
        
        // Total cell
        DataCell(Text(product.total.toString())),
        
        // Date cell
        DataCell(Text(product.dateAdded != null
            ? DateFormat('yyyy-MM-dd').format(product.dateAdded!)
            : 'No date')),
            
        // Action cell
        DataCell(
          TTableActionButtons(
            onEditPressed: () {
              Get.to(
                () => EditAddProductForm(product: product),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            onDeletePressed: () {
              _showDeleteDialog(Get.context!, product);
            },
          ),
        ),
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