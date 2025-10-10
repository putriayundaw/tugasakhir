import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/models/borrowed_models.dart';
import 'package:absensi/features/authentication/screens/product_management/borrowed/add_borrowed/table/table_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class BorrowedProductsTable extends StatelessWidget {
  final List<BorrowedProductModels> products;
  
  const BorrowedProductsTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 800,
      columns: const [
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('Borrowers name')),
        DataColumn2(label: Text('Amount')),
        DataColumn2(label: Text('Date')),
        DataColumn2(label: Text('Description')),
        DataColumn2(label: Text('Actions')),
      ],
      source: BorrowedProductRows(borrowedProducts: products),
    );
  }
}