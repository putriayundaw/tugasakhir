import 'package:absensi/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:absensi/features/authentication/controller/productManagement/borrowed_controller.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:absensi/routes/routes.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BorrowedProductRows extends DataTableSource {
  final List<BorrowedProductModels> borrowedProducts;
  final BorrowedProductController controller = Get.find<BorrowedProductController>();

  BorrowedProductRows({required this.borrowedProducts});

  void deleteProduct(int index) async {
    if (index < 0 || index >= borrowedProducts.length) return;
    
    final product = borrowedProducts[index];
    if (product.id == null) {
      Get.snackbar(
        'Error', 
        'Product ID is null',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      // Tampilkan loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final result = await BorrowedProductController.deleteBorrowedProduct(product.id!);
      
      Get.back(); // Tutup loading

      if (result['success'] == true) {
        // Refresh data menggunakan controller
        await controller.loadProducts();
        
        Get.snackbar(
          'Success', 
          result['message'] ?? 'Borrowed product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: TColors.primary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error', 
          result['message'] ?? 'Failed to delete product',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
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
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  DataRow2 getRow(int index) {
    if (index >= borrowedProducts.length) {
      return DataRow2(cells: [
        const DataCell(Text('No data')),
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('')),
        const DataCell(Text('')),
      ]);
    }

    final product = borrowedProducts[index];
    
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
        DataCell(Text(product.deskripsi ?? '-')),
        DataCell(
          TTableActionButtons(
            onEditPressed: () async {
              final result = await Get.toNamed(
                TRoutes.editborrowedProduct,
                arguments: product
              );
              if (result != null && result is BorrowedProductModels) {
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

  void showDeleteConfirmation(int index) {
    if (index < 0 || index >= borrowedProducts.length) return;
    
    final product = borrowedProducts[index];
    
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.namaBarang}"?'),
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
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => borrowedProducts.length;

  @override
  int get selectedRowCount => 0;
}