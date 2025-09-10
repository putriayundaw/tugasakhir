import 'package:absensi/common/widgets/containers/rounded_container.dart';
import 'package:absensi/features/authentication/controller/dashboard_controller.dart';
import 'package:absensi/utils/constans/colors.dart';
import 'package:absensi/utils/constans/sizes.dart';
import 'package:absensi/utils/helpers/helper_functions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OrderRows extends DataTableSource {
  final controller = DashboardController.instance;

  @override  
  DataRow? getRow(int index) {
    // Pastikan indeks yang diminta tidak melebihi panjang daftar
    if (index >= DashboardController.orders.length) {
      return null;  // Kembalikan null jika indeks tidak valid
    }

    final order = DashboardController.orders[index];
    return DataRow2(
      cells: [
        DataCell(
          Text(
            'order',
            style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: TColors.primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        const DataCell(Text('5 Items')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
            backgroundColor: THelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
            child: Text(
              order.status.name.capitalize.toString(),
              style: TextStyle(color: THelperFunctions.getOrderStatusColor(order.status)),
            ),
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => DashboardController.orders.length;

  @override
  int get selectedRowCount => 0;
}
