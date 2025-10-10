import 'package:absensi/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:absensi/common/widgets/images/t_rounded_image.dart';
import 'package:absensi/features/authentication/controller/productManagement/inStock_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/add_inStock/models/inStock_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_in/edit_inStock/widgets/edit_inStock_form.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/enums.dart';
import 'package:absensi/utils/constans/image_strings.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InProductRows extends DataTableSource {
  final List<InStockProductModel> product;
  final InstockController controller;
  final VoidCallback onDataChanged;

  InProductRows({
    required this.product,
    required this.controller,
    required this.onDataChanged,
  });

  // Method untuk show delete confirmation
  void _showDeleteDialog(BuildContext context, InStockProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.product}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Panggil method delete dari controller yang sudah di-pass
              await controller.deleteProduct(
                id: product.id,
                context: context,
              );
              // Panggil callback untuk refresh data
              onDataChanged();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  DataRow? getRow(int index) {
    if (index >= product.length) return null;
    
    final currentProduct = product[index];

    return DataRow2(
      cells: [
        // Product image cell - gunakan imageUrl dari model jika ada
      
        
        // Name cell
        DataCell(Text(currentProduct.product)),
        
        // Price cell - format price dengan separator ribuan
        DataCell(Text(_formatPrice(currentProduct.price))),
        
        // Total cell
        DataCell(Text(currentProduct.total.toString())),
        
        // Parent Product cell
       
        
        // Date cell - format tanggal dengan benar
        DataCell(Text(currentProduct.dateAdded != null
            ? DateFormat('yyyy-MM-dd').format(currentProduct.dateAdded!)
            : 'No date')),
            
        // Description cell
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              currentProduct.description.isNotEmpty 
                  ? currentProduct.description 
                  : 'No description',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
            
        // Action cell
        DataCell(
          TTableActionButtons(
            onEditPressed: () {
              // Navigasi ke halaman edit dengan membawa data produk
              Get.to(
                () => EditInStockForm(product: currentProduct),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            onDeletePressed: () {
              // Tambahkan konfirmasi delete
              _showDeleteDialog(Get.context!, currentProduct);
            },
          ),
        ),
      ],
    );
  }

  // Helper method untuk format harga
  String _formatPrice(double price) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(price);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => product.length;

  @override
  int get selectedRowCount => 0;
}