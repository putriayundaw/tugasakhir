import 'package:absensi/features/authentication/screens/product_management/all_product/models/allproduct_models.dart';
import 'package:absensi/features/authentication/screens/product_management/all_product/table/table_source.dart';
import 'package:absensi/features/authentication/screens/home/dashboard/widgets/data_table/paginated_data_table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AllProductsTable extends StatefulWidget {
  const AllProductsTable({
    super.key,
    required this.products, // Tambahkan parameter products
  });

  final List<AllProductModel> products; // Deklarasi parameter

  @override
  _AllProductsTableState createState() => _AllProductsTableState();
}

class _AllProductsTableState extends State<AllProductsTable> {
  late AllProductsRows _dataSource;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _dataSource = AllProductsRows(products: widget.products); // Gunakan widget.products
    isLoading = false; // Tidak perlu loading karena data sudah diterima
  }

  @override
  void didUpdateWidget(AllProductsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update data source ketika products berubah
    if (widget.products != oldWidget.products) {
      setState(() {
        _dataSource = AllProductsRows(products: widget.products);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(child: Text('Error: $error'));
    }

    return TPaginatedDataTable(
      minWidth: 700,
      columns: const [
        DataColumn2(label: Text('Image')),
        DataColumn2(label: Text('Name')),
        DataColumn2(label: Text('Price')),
        DataColumn2(label: Text('Stock')),
        DataColumn2(label: Text('Borrowed')),
        DataColumn2(label: Text('Returned')),
      ],
      source: AllProductsRows(products: widget.products), // Gunakan widget.products
    );
  }
}