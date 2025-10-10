import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/models/returned_models.dart';
import 'package:absensi/features/authentication/screens/product_management/returned/add_returned/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ReturnedProductsTable extends StatelessWidget {
  final List<ReturnedProductModels> products;
  
  const ReturnedProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 800,
      columns: const [
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('Borrower name')),
        DataColumn2(label: Text('Amount')),
        DataColumn2(label: Text('Date')),
        DataColumn2(label: Text('Actions')),
      ],
      source: ReturnedProductRows(returnedProducts: products),
    );
  }
}