import 'package:absensi/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:absensi/features/authentication/controller/productManagement/returned_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/models/returned_models.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReturnedProductRows extends DataTableSource {
  final List<ReturnedProductModels> returnedProducts;
  final ReturnedProductController controller = Get.find<ReturnedProductController>();

  ReturnedProductRows({required this.returnedProducts});

  void deleteProduct(int index) async {
    if (index < 0 || index >= returnedProducts.length) return;
    
    final product = returnedProducts[index];
    if (product.id == 0) {
      Get.snackbar('Error', 'Product ID is invalid');
      return;
    }
    
    try {
      // Tampilkan loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await ReturnedProductController.deleteReturnedProduct(product.id);
      
      Get.back(); // Tutup loading

      if (result['success'] == true) {
        // Refresh data menggunakan controller
        await controller.loadProducts();
        
        Get.snackbar(
          'Success', 
          result['message'] ?? 'Returned product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.primary,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error', 
          result['message'] ?? 'Failed to delete product',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Tutup loading jika error
      Get.snackbar(
        'Error', 
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showDeleteConfirmation(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${returnedProducts[index].namaBarang}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteProduct(index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  DataRow2 getRow(int index) {
    if (index >= returnedProducts.length) {
      return const DataRow2(cells: [
        DataCell(Text('No data')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ]);
    }

    final product = returnedProducts[index];
    
    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              Expanded(
                child: Text(
                  product.namaBarang,
                  style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: TColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(product.namaPeminjam)),
        DataCell(Text(product.total.toString())),
        DataCell(Text(
          DateFormat('dd/MM/yyyy').format(product.tanggal)
        )),
        DataCell(
          TTableActionButtons(
            onEditPressed: () async {
              final result = await Get.toNamed(
                TRoutes.editreturnedProduct,
                arguments: product
              );
              if (result != null && result is ReturnedProductModels) {
                // Refresh data setelah edit
                await controller.loadProducts();
              }
            },
            onDeletePressed: () => showDeleteConfirmation(index),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => returnedProducts.length;

  @override
  int get selectedRowCount => 0;
}