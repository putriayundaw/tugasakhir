import 'package:absensi/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:absensi/features/authentication/controller/productManagement/outStock_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/add_outStock/models/OutStock_models.dart';
import 'package:absensi/features/authentication/screens/product_management/stock_out/edit_outstock/widgets/edit_outproduct_form.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OutProductRows extends DataTableSource {
  final List<OutStockProductModel> product;
  final OutstockController controller;
  final VoidCallback onDataChanged;

  OutProductRows({
    required this.product,
    required this.controller,
    required this.onDataChanged,
  });

  void _showDeleteDialog(BuildContext context, OutStockProductModel product) {
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
              await controller.deleteProduct(
                id: product.id,
                context: context,
              );
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
        // Product image cell
        // DataCell(
        //   Row(
        //     children: [
        //       TRoundedImage(
        //         width: 50,
        //         height: 50,
        //         padding: TSizes.sm,
        //         image: currentProduct.imageUrl.isNotEmpty 
        //             ? currentProduct.imageUrl 
        //             : TImages.defaultImage,
        //         imageType: currentProduct.imageUrl.isNotEmpty 
        //             ? ImageType.network 
        //             : ImageType.asset,
        //         borderRadius: TSizes.borderRadiusMd,
        //         backgroundColor: TColors.primaryBackground,
        //       ),
        //     ],
        //   ),
        // ),
        
        // Name cell
        DataCell(Text(currentProduct.product)),
        
        // Price cell
        DataCell(Text(_formatPrice(currentProduct.price))),
        
        // Total cell
        DataCell(Text(currentProduct.total.toString())),
        
        // Parent Product cell
       
        // Date cell
        DataCell(Text(DateFormat('yyyy-MM-dd').format(currentProduct.dateCreated))),
            
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
              Get.to(
                () => EditOutStockForm(product: currentProduct),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              )?.then((_) => onDataChanged());
            },
            onDeletePressed: () {
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