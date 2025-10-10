import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/Models/addproduct_model.dart';
import 'package:absensi/features/authentication/screens/product_management/addProduct/add_product/table/table_source.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AddProductsTable extends StatelessWidget {
  const AddProductsTable({super.key, required this.products});

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 800, // Increased width to accommodate image column
      columns: const [
        DataColumn2(label: Text('Image')),
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('Price')),
        DataColumn2(label: Text('Total')),

        DataColumn2(label: Text('Date')),
        DataColumn2(label: Text('Action'), fixedWidth: 120),
      ],
      source: AddProductsRows(products: products),
    );
  }
}